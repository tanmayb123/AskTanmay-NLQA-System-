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
"""Term Extractor

$Id: extract.py 100557 2009-05-30 15:48:36Z srichter $
"""
import zope.interface

from topia.termextract import interfaces, tag

SEARCH = 0
NOUN = 1

def permissiveFilter(word, occur, strength):
    return True

class DefaultFilter(object):

    def __init__(self, singleStrengthMinOccur=3, noLimitStrength=2):
        self.singleStrengthMinOccur = singleStrengthMinOccur
        self.noLimitStrength = noLimitStrength

    def __call__(self, word, occur, strength):
        return ((strength == 1 and occur >= self.singleStrengthMinOccur) or
                (strength >= self.noLimitStrength))

def _add(term, norm, multiterm, terms):
    multiterm.append((term, norm))
    terms.setdefault(norm, 0)
    terms[norm] += 1

class TermExtractor(object):
    zope.interface.implements(interfaces.ITermExtractor)

    def __init__(self, tagger=None, filter=None):
        if tagger is None:
            tagger = tag.Tagger()
            tagger.initialize()
        self.tagger = tagger
        if filter is None:
            filter = DefaultFilter()
        self.filter = filter

    def extract(self, taggedTerms):
        """See interfaces.ITermExtractor"""
        terms = {}
        # Phase 1: A little state machine is used to build simple and
        # composite terms.
        multiterm = []
        state = SEARCH
        while taggedTerms:
            term, tag, norm = taggedTerms.pop(0)
            if state == SEARCH and tag.startswith('N'):
                state = NOUN
                _add(term, norm, multiterm, terms)
            elif state == SEARCH and tag == 'JJ' and term[0].isupper():
                state = NOUN
                _add(term, norm, multiterm, terms)
            elif state == NOUN and tag.startswith('N'):
                _add(term, norm, multiterm, terms)
            elif state == NOUN and not tag.startswith('N'):
                state = SEARCH
                if len(multiterm) > 1:
                    word = ' '.join([word for word, norm in multiterm])
                    terms.setdefault(word, 0)
                    terms[word] += 1
                multiterm = []
        # Phase 2: Only select the terms that fulfill the filter criteria.
        # Also create the term strength.
        return [
            (word, occur, len(word.split()))
            for word, occur in terms.items()
            if self.filter(word, occur, len(word.split()))]

    def __call__(self, text):
        """See interfaces.ITermExtractor"""
        terms = self.tagger(text)
        return self.extract(terms)

    def __repr__(self):
        return '<%s using %r>' %(self.__class__.__name__, self.tagger)
