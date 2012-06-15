# Cordon Sanitaire

From Wikipedia:

> Cordon sanitaire -- or quarantine line -- is a French phrase that, literally
> translated, means "sanitary cordon". Though in French it originally denoted a barrier
> implemented to stop the spread of disease, it has often been used in English in a
> metaphorical sense to refer to attempts to prevent the spread of an ideology deemed
> unwanted or dangerous, such as the containment policy adopted by George F. Kennan
> against the Soviet Union.

I've never been a big fan of the way RSpec adds <code>#should</code> and <code>#should_not</code> to Kernel, but until recently I'd never been able to articulate why.  Then I worked on a project that became <a href="https://github.com/geeksam/kookaburra/">Kookaburra</a>, and I found a specific reason to be annoyed.

Basically, putting <code>#should</code> on all objects gives you the freedom to <strike>shoot yourself in the foot</strike>^H^H^H put RSpec expectations *anywhere*, not just inside an <code>#it</code> block.  So, I went looking for a way to make <code>#should</code> explode if it was called outside a specific context.

After several false starts and horrible ideas, I've got something that actually isn't too bad.

Cordon makes specs look like this:

<pre><code lang="ruby">describe "a toggle switch" do
  it "should be on when flipped up" do
    toggle = ToggleSwitch.new
    toggle.flip_up
    <em><strong>assert_that</strong></em>(toggle).should be_on
  end
end</code></pre>

Cordon lets you declare certain methods as "off-limits" to casual code.  Any calls to blacklisted methods will raise a Cordon::Violation exception -- <em>unless</em> they're called on the object thats passed as the single argument to <code>Object#assert\_that</code>, as shown above.  What <code>#assert\_that</code> does is temporarily add its argument to a whitelist.  This effectively gives that object permission to call any blacklisted method once (and only once!).

## Quick setup for popular testing frameworks

Currently, Cordon ships with shorthand configuration items for RSpec and MiniTest::Spec.  You can set these up like so:

### RSpec
<pre><code lang="ruby">require 'rspec'
Cordon.embargo :rspec</code></pre>

### MiniTest::Spec
<pre><code lang="ruby">require 'minitest/autorun'
Cordon.embargo :minitest_spec</code></pre>

In both examples, note that Cordon's <code>.embargo</code> method must be called *after* the test framework has been loaded.


## TODO

### Switch to RSpec 2.11 when it comes out: http://myronmars.to/n/dev-blog/2012/06/rspecs-new-expectation-syntax

<!-- Apparently Markdown and HTML don't mix, because "* <strike>foo</strike>" doesn't work the way I thought it should -->
<ul>
  <li><strike>Add a declarative API to customize the name of the function that wraps assertions</strike></li>
  <li>RDoc</li>
  <li>Add a "detection mode" which rescues Cordon::Violation, records the backtrace, and reports all violations in a Kernel#at_exit callback. (UPDATE:  added Cordon.monitor for frameworks, and Cordon.watchlist for methods, but didn't get #at_exit working yet.)</li>
  <li>MAYBE: Figure out how to raise Cordon::Violation only when in (or not in?) a certain calling context (this could be hairy), which might make #assert_that optional</li>
  <li>probably some other stuff I can't think of at the moment</li>
</ul>



## Contributing to Cordon
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.



## Copyright

Copyright (c) 2012 Sam Livingston-Gray. See LICENSE.txt for further details.
