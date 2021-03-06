# jshint: describe:true, it: true, runs:true, waitsFor:true 

# global: APP:true, mediaCheck:true 
unless window.opener
  $("body").prepend "<p>This test suite needs to run in a popup window. <a id=\"runTests\" href=\"SpecRunner.html\">Run Tests</a>.</p>"
  $("#runTests").on "click", (e) ->
    e.preventDefault()
    window.open location.href + "?" + Math.random(), "Nav Test Suite", "scrollbars=1,resizable=1"

else
  describe "Nav", ->
    describe "in the small context", ->
      $navToggle = undefined
      $mainNav = undefined
      beforeEach ->
        
        ###
        Load in the some HTML to simulate the navigation markup
        ###
        loadFixtures "fixtures/nav.html"
        NAV.init()
        
        ###
        Cache some selectors that will be reused.
        ###
        $navToggle = $("#navToggle")
        $mainNav = $("#mainNav")

      it "should verify that the window is less than 450px.", ->
        runs ->
          resizeTo 400, 780

        waitsFor (->
          document.width is 400
        ), "the browser width to be 400px.", 250

      it "should toggle the nav when clicking on the show nav icon", ->
        expect($mainNav.is(":hidden")).toBe true
        $navToggle.trigger "click"
        expect($mainNav.is(":visible")).toBe true
        $navToggle.trigger "click"
        expect($mainNav.is(":hidden")).toBe true

      it "should slide the sub navs open on the first click ", ->
        
        ###
        Get a hook to the nav item that the test will "click" on.
        ###
        $subMenu = $(".subMenu:first")
        
        ###
        Get a hook to the subNav that the test will b elooking for.
        ###
        $menuLink = $subMenu.siblings("a")
        
        ###
        Open up the main nav
        ###
        $navToggle.trigger "click"
        
        ###
        Click on the submenu and wait to verify that it opens
        ###
        runs ->
          $menuLink.trigger "click"

        waitsFor (->
          $subMenu.is ":visible"
        ), "the submenu to be visible", 500
        runs ->
          expect($subMenu.is(":visible")).toBe true

        
        ###
        Click on the submenu again and wait to verify that it closes
        ###
        runs ->
          $menuLink.trigger "click"

        waitsFor (->
          $subMenu.is ":hidden"
        ), "the submenu to be hidden", 500
        runs ->
          expect($subMenu.is(":hidden")).toBe true


      it "should be able to clear all JS applied styles", ->
        $navToggle.trigger "click"
        NAV.clear()
        expect($mainNav.attr("style")).toBe `undefined`


    describe "when switching from the small to large context", ->
      $navToggle = undefined
      $mainNav = undefined
      beforeEach ->
        
        ###
        Load in the some HTML to simulate the navigation markup
        ###
        loadFixtures "fixtures/nav.html"
        NAV.init()
        
        ###
        Cache some selectors that will be reused.
        ###
        $navToggle = $("#navToggle")
        $mainNav = $("#mainNav")

      it "should verify that the window is less than 410px.", ->
        runs ->
          resizeTo 400, 780

        waitsFor (->
          document.width < 410
        ), "the browser width should be less than 410px.", 250

      it "should make sure that menus are still visible at large sizes", ->
        $navToggle.trigger "click"
        expect($mainNav.is(":visible")).toBe true
        $navToggle.trigger "click"
        expect($mainNav.is(":hidden")).toBe true
        runs ->
          resizeTo 600, 780

        waitsFor (->
          document.width >= 410
        ), "the browser width should be greater than 410px.", 250
        runs ->
          expect($mainNav.attr("style")).toBe `undefined`
          expect($mainNav.is(":visible")).toBe true



