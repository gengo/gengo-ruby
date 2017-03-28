|Build Status|

Gengo Ruby Library (for the `Gengo API <http://gengo.com/api/>`__)
==================================================================

Translating your tools and products helps people all over the world
access them; this is, of course, a somewhat tricky problem to solve.
`Gengo <http://gengo.com/>`__ is a service that offers
human-translation (which is often a higher quality than machine
translation), and an API to manage sending in work and watching jobs.
This is a Ruby interface to make using the API simpler (some would say
incredibly easy).

Installation & Requirements
---------------------------

Installing Gengo is fairly simple:

.. code:: sh

    $ gem install gengo

Tests - Running Them, etc
-------------------------

Gengo has a full suite of tests, however they're not currently
automated. Each script in the ``examples`` directory tests a different
Gengo API endpoint; run against those if you wish to test for now.

Question, Comments, Complaints, Praise?
---------------------------------------

If you have questions or comments and would like to reach us directly,
please feel free to do so at the following outlets. We love hearing from
developers!

-  Email: api [at] gengo dot com
-  Twitter: `@gengoit <https://twitter.com/gengoit>`__
-  IRC: `#gengo <irc://irc.freenode.net/gengo>`__

If you come across any issues, please file them on the `Github project
issue tracker <https://github.com/gengo/gengo-ruby/issues>`__. Thanks!

Documentation
-------------

The usage of the API is very simple - the most important part is getting
authenticated. To do this is just a few lines of code:

.. code:: ruby

    require 'gengo'

    gengo = Gengo::API.new({
        :public_key => 'your_public_key',
        :private_key => 'your_private_key',
        :sandbox => true, # Or false, depending on your work
    })

    # Get some information
    puts gengo.getAccountBalance()

With that, you can call any number of methods supported by this library.
The entire library is rdoc supported, so you can look at more method
information there. There's also a full suite of test code/examples,
located in the ``examples`` directory. Be sure to checkout the `Gengo
API documentation <http://developers.gengo.com>`__. Enjoy!

.. |Build Status| image:: https://secure.travis-ci.org/gengo/gengo-ruby.png
   :target: http://travis-ci.org/gengo/gengo-ruby
