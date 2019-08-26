/*
 * Get timeago
 *
 * © 2019 Cotes Chung
 * MIT License
 */

function timeago(date) {

  var now = new Date();
  var past = new Date(date);
  var seconds = Math.floor((now - past) / 1000);

  var interval = Math.floor(seconds / 31536000);

  if (interval >= 1) {
    return interval + " year" + (interval > 1? "s" : "") + " ago";
  }

  interval = Math.floor(seconds / 2592000);
  if (interval >= 1) {
    return interval + " month" + (interval > 1? "s" : "") + " ago";
  }

  interval = Math.floor(seconds / 604800);
  if (interval >= 1) {
    return interval + " week" + (interval > 1? "s" : "") + " ago";
  }

  interval = Math.floor(seconds / 86400);
  if (interval >= 1) {
    return interval + " day" + (interval > 1? "s" : "") + " ago";
  }

  interval = Math.floor(seconds / 3600);
  if (interval >= 1) {
    return interval + " hour" + (interval > 1? "s" : "") + " ago";
  }

  interval = Math.floor(seconds / 60);
  if ( interval >= 1) {
    return interval + " minute" + (interval > 1? "s" : "") + " ago";
  }

  return "just now";
}

function updateTimeago() {
  $(".timeago").each(function() {
    if ($(this).children("i").length > 0) {
      var node = $(this).children("i");
      var date = node.text().replace(/-/g, '/'); /* compatible with Safari */
      $(this).text(timeago(date));
      $(this).append(node);
    }
  });
}

$(function() {
  if ($(".timeago").length <= 0 ) {
    return;
  }
  updateTimeago();  /* run immediately */
  setInterval(updateTimeago, 60000);  /* loop every minutes */
});