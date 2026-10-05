/* SPDX-License-Identifier: GPL-3.0-or-later */
package net.jami.services

import net.jami.daemon.JamiService

/** Bridges the original single-ID UI to the account-scoped daemon API.
 * Never falls back to the currently selected account: a background call may
 * belong to a different account. Callbacks register ownership before dispatch.
 */
internal class CallAccountRegistry(private val lookup: (String) -> List<String>) {
    private val owners = object : LinkedHashMap<String, String>(128, 0.75f, true) {
        override fun removeEldestEntry(eldest: MutableMap.MutableEntry<String, String>?) = size > 2048
    }

    @Synchronized fun remember(accountId: String, id: String) {
        require(accountId.isNotEmpty() && id.isNotEmpty())
        owners[id] = accountId
    }

    @Synchronized fun accountFor(id: String?): String {
        require(!id.isNullOrEmpty()) { "A call or conference ID is required" }
        owners[id]?.let { return it }
        val matches = lookup(id).distinct()
        check(matches.size == 1) { "Cannot uniquely resolve call ownership: $id" }
        return matches.single().also { owners[id] = it }
    }
}

object CallAccounts {
    private val registry = CallAccountRegistry { id ->
        JamiService.getAccountList().filter { account ->
            JamiService.getCallList(account).contains(id) ||
                JamiService.getConferenceList(account).contains(id)
        }
    }
    fun remember(accountId: String, id: String) = registry.remember(accountId, id)
    fun accountFor(id: String?): String = registry.accountFor(id)
    fun allCalls(): List<String> = JamiService.getAccountList().flatMap { account ->
        JamiService.getCallList(account).onEach { registry.remember(account, it) }
    }
}
