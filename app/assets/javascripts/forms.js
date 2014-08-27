/* Setup the select2 functions */
$(document).ready(function() {

  $('select#hometeam').select2({
    placeholder: "Home Team",
    allowClear: true,
    width: '220px'
  });

  $('select#awayteam').select2({
    placeholder: "Away Team",
    allowClear: true,
    width: '220px'
  });

  $('select#pick').select2({ width: '200px' });

});

/* setup cocoon nested forms insertion mode */
$(document).ready(function() {
  $("a.add_fields").
    data("association-insertion-position", 'before').
    data("association-insertion-node", 'this');
});

$(document).ready(function() {
  $('form').on('cocoon:after-insert', function() {
    /* ... do something ... */
    $('select#awayteam').select2({
      placeholder: "Away Team",
      allowClear: true,
      width: '220px'
    });

    $('select#hometeam').select2({
      placeholder: "Home Team",
      allowClear: true,
      width: '220px'
    });
  });
});

