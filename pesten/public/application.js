(function() {
  var addPlayer, app, chooseName, findPlayer, focus, handleCardClick, handleChatClick, handleJoinClick, hasName, notice, socket;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  app = {};
  socket = io.connect();
  chooseName = function() {
    app.name = window.location.search.substring(1);
    while (!hasName()) {
      app.name = prompt("Pick a nickname!");
    }
    return socket.emit('join room', {
      name: app.name
    });
  };
  hasName = function() {
    return (app.name != null) && app.name.replace(/^\s+|\s+$/g, '') !== "";
  };
  focus = function() {
    return $('#box').focus();
  };
  handleChatClick = function(event) {
    var box;
    event.preventDefault();
    box = $('#box');
    socket.emit('say', box.val());
    return box.val('').focus();
  };
  handleCardClick = function(event) {
    var cardId;
    cardId = event.target.id.replace('card_', '');
    return socket.emit('play card', {
      cardId: +cardId
    });
  };
  handleJoinClick = __bind(function(event) {
    event.preventDefault();
    $(event.target).remove();
    return alert("You clicked this button");
  }, this);
  findPlayer = function(player) {
    return $("#players li#player_" + player.id);
  };
  addPlayer = function(player) {
    return $('#players').append("<li id='player_" + player.id + "'>" + player.name + "</li>");
  };
  notice = function(message, type) {
    if (type == null) {
      type = "normal";
    }
    $('#panel').append("<p class='" + type + "'>" + (message.replace(/</g, '&lt;')) + "</p>");
    $('#panel').scrollTop(1000000);
    return focus();
  };
  socket.on('welcome', function(data) {
    var player, _i, _len, _ref;
    notice("Welcome, " + data.player.name);
    _ref = data.others;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      player = _ref[_i];
      addPlayer(player);
    }
    findPlayer(data.player).addClass('me');
    return app.player = data.player;
  });
  socket.on('player joined', function(data) {
    notice("Player " + data.player.name + " has joined the room");
    return addPlayer(data.player);
  });
  socket.on('player left', function(data) {
    notice("Player " + data.player.name + " has left the room");
    return findPlayer(data.player).remove();
  });
  socket.on('you said', function(data) {
    return notice("You said: " + data.message, 'youSaid');
  });
  socket.on('player said', function(data) {
    return notice("" + data.player.name + " said: " + data.message, 'playerSaid');
  });
  jQuery(function() {
    $('#chat').click(handleChatClick);
    $('#join').click(handleJoinClick);
    $(window).click(focus);
    focus();
    return chooseName();
  });
}).call(this);
