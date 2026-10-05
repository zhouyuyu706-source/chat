package net.jami.services

import org.junit.Assert.assertEquals
import org.junit.Test

class CallAccountsTest {
    @Test fun callbackOwnershipDoesNotFollowSelectedAccount() {
        val registry = CallAccountRegistry { listOf("wrong-selected-account") }
        registry.remember("background-account", "call-1")
        assertEquals("background-account", registry.accountFor("call-1"))
    }
    @Test fun resolvesExistingConference() {
        val registry = CallAccountRegistry { id -> if (id == "conference") listOf("owner") else emptyList() }
        assertEquals("owner", registry.accountFor("conference"))
    }
    @Test(expected = IllegalStateException::class) fun rejectsUnknownCall() {
        CallAccountRegistry { emptyList() }.accountFor("unknown")
    }
    @Test(expected = IllegalStateException::class) fun rejectsAmbiguousOwnership() {
        CallAccountRegistry { listOf("one", "two") }.accountFor("collision")
    }
    @Test(expected = IllegalArgumentException::class) fun rejectsMissingId() {
        CallAccountRegistry { listOf("owner") }.accountFor(null)
    }
}
