// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

//= require jquery
//= require jquery_ujs

$(document).ready(function() {
  $('#search-input').on('input', function() {
    var searchTerm = $(this).val();
    if (searchTerm.length >= 2) {
      $.ajax({
        url: '/search',
        method: 'GET',
        data: { term: searchTerm },
        dataType: 'json',
        success: function(data) {
          var resultsDiv = $('#search-results');
          resultsDiv.empty();
          if (data.length > 0) {
            var resultList = $('<ul class="list-group"></ul>');
            data.forEach(function(item) {
              var listItem = $('<li class="list-group-item"></li>');
              var link = $('<a></a>');
              link.text(item);
              var profileId = item.split(' - ')[0];
              link.attr('href', '/profiles/' + profileId);
              listItem.append(link);
              resultList.append(listItem);
            });
            resultsDiv.append(resultList);
          } else {
            resultsDiv.text('No results found.');
          }
        }
      });
    } else {
      $('#search-results').empty();
    }
  });
});
