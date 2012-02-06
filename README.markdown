# Cordon Sanitaire

From Wikipedia:

> Cordon sanitaire -- or quarantine line -- is a French phrase that, literally
> translated, means "sanitary cordon". Though in French it originally denoted a barrier
> implemented to stop the spread of disease, it has often been used in English in a
> metaphorical sense to refer to attempts to prevent the spread of an ideology deemed
> unwanted or dangerous, such as the containment policy adopted by George F. Kennan
> against the Soviet Union.

I've never been a big fan of the way RSpec adds <code>#should</code> and <code>#should_not</code> to Kernel, but until recently I'd never been able to articulate why.  Then I worked on a project that became https://github.com/geeksam/kookaburra/ and I found a specific reason to be annoyed.

Basically, putting <code>#should</code> on all objects gives you the freedom to <s>shoot yourself in the foot</s> put RSpec expectations *anywhere*, not just inside an <code>#it</code> block.  So, I went looking for a way to make <code>#should</code> explode if it was called outside a specific context.

Cordon makes specs look like this:

<pre><code lang="ruby">
  describe "a toggle switch" do
    it "should be on when flipped up" do
      toggle = ToggleSwitch.new
      toggle.flip_up
      assert_that(toggle).should be_on
    end
  end
</code></pre>



## TODO

- Write integration macros (and tests, obviously) for various spec frameworks:
  - RSpec
  - MiniTest::Spec
  - Yoda
  - ?
- Add a declarative API to customize the name of the function that wraps assertions
- probably some other stuff I can't think of at the moment



## Contributing to Cordon
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.



## Copyright

Copyright (c) 2012 Sam Livingston-Gray. See LICENSE.txt for
further details.
