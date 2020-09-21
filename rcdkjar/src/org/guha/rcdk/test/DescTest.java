package org.guha.rcdk.test;

import junit.framework.Assert;
import junit.framework.TestCase;
import org.guha.rcdk.descriptors.DescriptorUtilities;

public class DescTest extends TestCase {
    String home = "/Users/rguha/";

    public void testDNames() {
        String[] dn = DescriptorUtilities.getDescriptorNamesByCategory("topological");
        Assert.assertNotNull(dn);
        Assert.assertTrue(dn.length > 0);
    }
}