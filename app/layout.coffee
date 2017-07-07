blank_page = (replace) ->
  $('#app-layout').empty()

module.exports = {
  
  render: (view) ->
    App.view = view
    $(App.events).off('View')
    Page = App.pages[view]

    if Page == undefined
      blank_page()
      console.log 'View.missing', view
    else
      App.page = new Page
      App.page.render(blank_page())
}

