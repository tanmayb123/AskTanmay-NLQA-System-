##############################################################################
#
# Copyright (c) 2009 Zope Foundation and Contributors.
# All Rights Reserved.
#
# This software is subject to the provisions of the Zope Public License,
# Version 2.1 (ZPL).  A copy of the ZPL should accompany this distribution.
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY AND ALL EXPRESS OR IMPLIED
# WARRANTIES ARE DISCLAIMED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF TITLE, MERCHANTABILITY, AGAINST INFRINGEMENT, AND FITNESS
# FOR A PARTICULAR PURPOSE.
#
##############################################################################
"""Test Setup

$Id: tests.py 100552 2009-05-30 15:16:11Z srichter $
"""
__docformat__ = "reStructuredText"
import unittest
from zope.testing import doctest
from zope.testing.doctestunit import DocFileSuite

def printTaggedTerms(terms):
    for term, tag, norm in terms:
        print (
            term + ' '*(16-len(term)) +
            tag + ' '*(6-len(tag)) +
            norm )

def test_suite():
    return unittest.TestSuite((
        DocFileSuite(
            'README.txt',
            optionflags=doctest.NORMALIZE_WHITESPACE|doctest.ELLIPSIS,
            ),
        DocFileSuite(
            'example.txt',
            globs={'printTaggedTerms': printTaggedTerms},
            optionflags=doctest.NORMALIZE_WHITESPACE|doctest.ELLIPSIS,
            ),
        ))
