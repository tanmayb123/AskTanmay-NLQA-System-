===============
Term Extraction
===============

This package implements text term extraction by making use of a simple
Parts-Of-Speech (POS) tagging algorithm.

http://bioie.ldc.upenn.edu/wiki/index.php/Part-of-Speech


The POS Tagger
--------------

POS Taggers use a lexicon to mark words with a tag. A list of available tags
can be found at:

http://bioie.ldc.upenn.edu/wiki/index.php/POS_tags

Since words can have multiple tags, the determination of the correct tag is
not always simple. This implementation, however, does not try to infer
linguistic use and simply chooses the first tag in the lexicon.

  >>> from topia.termextract import tag
  >>> tagger = tag.Tagger()
  >>> tagger
  <Tagger for english>

To get the tagger ready for its work, we need to initialize it. In this
implementation the lexicon is loaded.

  >>> tagger.initialize()

Now we are ready to rock and roll.

Tokenizing
~~~~~~~~~~

The first step of tagging is to tokenize the text into terms.

  >>> tagger.tokenize('This is a simple example.')
  ['This', 'is', 'a', 'simple', 'example', '.']

While most tokenizers ignore punctuation, it is important for us to keep it,
since we need it later for the term extraction. Let's now look at some more
complex cases:

- Quoted Text

  >>> tagger.tokenize('This is a "simple" example.')
  ['This', 'is', 'a', '"', 'simple', '"', 'example', '.']

  >>> tagger.tokenize('"This is a simple example."')
  ['"', 'This', 'is', 'a', 'simple', 'example', '."']

- Non-letters within words.

  >>> tagger.tokenize('Parts-Of-Speech')
  ['Parts-Of-Speech']

  >>> tagger.tokenize('amazon.com')
  ['amazon.com']

  >>> tagger.tokenize('Go to amazon.com.')
  ['Go', 'to', 'amazon.com', '.']

- Various punctuation.

  >>> tagger.tokenize('Quick, go to amazon.com.')
  ['Quick', ',', 'go', 'to', 'amazon.com', '.']

  >>> tagger.tokenize('Live free; or die?')
  ['Live', 'free', ';', 'or', 'die', '?']

- Tolerance to incorrect punctuation.

  >>> tagger.tokenize('Hi , I am here.')
  ['Hi', ',', 'I', 'am', 'here', '.']

- Possessive structures.

  >>> tagger.tokenize("my parents' car")
  ['my', 'parents', "'", 'car']
  >>> tagger.tokenize("my father's car")
  ['my', 'father', "'s", 'car']

- Numbers.

  >>> tagger.tokenize("12.4")
  ['12.4']
  >>> tagger.tokenize("-12.4")
  ['-12.4']
  >>> tagger.tokenize("$12.40")
  ['$12.40']

- Dates.

  >>> tagger.tokenize("10/3/2009")
  ['10/3/2009']
  >>> tagger.tokenize("3.10.2009")
  ['3.10.2009']

Okay, that's it.


Tagging
-------

The next step is tagging. Tagging is done in two phases. During the first
phase terms are assigned a tag by looking at the lexicon and the normalized
form is set to the term itself. In the second phase, a set of rules is applied
to each tagged term and the tagging and normalization is tweaked.

  >>> tagger('This is a simple example.')
  [['This', 'DT', 'This'],
   ['is', 'VBZ', 'is'],
   ['a', 'DT', 'a'],
   ['simple', 'JJ', 'simple'],
   ['example', 'NN', 'example'],
   ['.', '.', '.']]

So wow, this determination was dead on. Let's try a plural form noun and see
what happens:

  >>> tagger('These are simple examples.')
  [['These', 'DT', 'These'],
   ['are', 'VBP', 'are'],
   ['simple', 'JJ', 'simple'],
   ['examples', 'NNS', 'example'],
   ['.', '.', '.']]

So far so good. Let's test a few more cases:

  >>> tagger("The fox's tail is red.")
  [['The', 'DT', 'The'],
   ['fox', 'NN', 'fox'],
   ["'s", 'POS', "'s"],
   ['tail', 'NN', 'tail'],
   ['is', 'VBZ', 'is'],
   ['red', 'JJ', 'red'],
   ['.', '.', '.']]

  >>> tagger("The fox can't really jump over the fox's tail.")
  [['The', 'DT', 'The'],
   ['fox', 'NN', 'fox'],
   ['can', 'MD', 'can'],
   ["'t", 'RB', "'t"],
   ['really', 'RB', 'really'],
   ['jump', 'VB', 'jump'],
   ['over', 'IN', 'over'],
   ['the', 'DT', 'the'],
   ['fox', 'NN', 'fox'],
   ["'s", 'POS', "'s"],
   ['tail', 'NN', 'tail'],
   ['.', '.', '.']]

Rules
~~~~~

- Correct Default Noun Tag

    >>> tagger('Ikea')
    [['Ikea', 'NN', 'Ikea']]
    >>> tagger('Ikeas')
    [['Ikeas', 'NNS', 'Ikea']]

- Verify proper nouns at beginning of sentence.

    >>> tagger('. Police')
    [['.', '.', '.'], ['police', 'NN', 'police']]
    >>> tagger('Police')
    [['police', 'NN', 'police']]
    >>> tagger('. Stephan')
    [['.', '.', '.'], ['Stephan', 'NNP', 'Stephan']]

- Determine Verb after Modal Verb

    >>> tagger('The fox can jump')
    [['The', 'DT', 'The'],
     ['fox', 'NN', 'fox'],
     ['can', 'MD', 'can'],
     ['jump', 'VB', 'jump']]
    >>> tagger("The fox can't jump")
    [['The', 'DT', 'The'],
     ['fox', 'NN', 'fox'],
     ['can', 'MD', 'can'],
     ["'t", 'RB', "'t"],
     ['jump', 'VB', 'jump']]
    >>> tagger('The fox can really jump')
    [['The', 'DT', 'The'],
     ['fox', 'NN', 'fox'],
     ['can', 'MD', 'can'],
     ['really', 'RB', 'really'],
     ['jump', 'VB', 'jump']]

- Normalize Plural Forms

    >>> tagger('examples')
    [['examples', 'NNS', 'example']]
    >>> tagger('stresses')
    [['stresses', 'NNS', 'stress']]
    >>> tagger('cherries')
    [['cherries', 'NNS', 'cherry']]

  Some cases that do not work:

    >>> tagger('men')
    [['men', 'NNS', 'men']]
    >>> tagger('feet')
    [['feet', 'NNS', 'feet']]


Term Extraction
---------------

Now that we can tag a text, let's have a look at the term extractions.

  >>> from topia.termextract import extract
  >>> extractor = extract.TermExtractor()
  >>> extractor
  <TermExtractor using <Tagger for english>>

As you can see, the extractor maintains a tagger:

  >>> extractor.tagger
  <Tagger for english>

When creating an extractor, you can also pass in a tagger to avoid frequent
tagger initialization:

  >>> extractor = extract.TermExtractor(tagger)
  >>> extractor.tagger is tagger
  True

Let's get the terms for a simple text.

  >>> extractor("The fox can't jump over the fox's tail.")
  []

We got no terms. That's because by default at least 3 occurences of a
term must be detected, if the term consists of a single word.

The extractor maintains a filter component. Let's register the trivial
permissive filter, which simply return everything that the extractor suggests:

  >>> extractor.filter = extract.permissiveFilter
  >>> extractor("The fox can't jump over the fox's tail.")
  [('tail', 1, 1), ('fox', 2, 1)]

But let's look at the default filter again, since it allows tweaking its
parameters:

  >>> extractor.filter = extract.DefaultFilter(singleStrengthMinOccur=2)
  >>> extractor("The fox can't jump over the fox's tail.")
  [('fox', 2, 1)]

Let's now have a look at multi-word terms. Oftentimes multi-word nouns and
proper names occur only once or twice in a text. But they are often great
terms! To handle this scenario, the concept of "strength" was
introduced. Currently the strength is simply the amount of words in the
term. By default, all terms with a strength larger than 1 are selected
regardless of the number of occurances.

  >>> extractor('The German consul of Boston resides in Newton.')
  [('German consul', 1, 2)]

