/* Setup the select2 functions */
$(document).ready(function() {

  $('select#hometeam').select2({
    placeholder: "Home Team",
    allowClear: true
  });

  $('select#awayteam').select2({
    placeholder: "Away Team",
    allowClear: true
  });

  $('select#pick').select2();
});

/* setup cocoon nested forms insertion mode */
$(document).ready(function() {
  $("a.add_fields").
    data("association-insertion-position", 'before').
    data("association-insertion-node", 'this');
});

$(document).ready(function() {
  $('#awayTeamIndex')
      .on('cocoon:after-insert', function() {
        /* ... do something ... */
        $('select#awayteam').select2({
          placeholder: "Away Team",
          allowClear: true
        });
      });
});

