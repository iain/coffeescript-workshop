(function() {
  var addPlayer, app, chooseName, findPlayer, focus, handleCardClick, handleChatClick, handleJoinClick, handleResetClick, hasName, notice, putOnStack, socket;
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
    return socket.emit('join game');
  }, this);
  handleResetClick = __bind(function(event) {
    event.preventDefault();
    if (confirm("Are you sure you want to reset the game?")) {
      return socket.emit("reset game");
    }
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
    return $('#panel').scrollTop(1000000);
  };
  putOnStack = function(card) {
    $('#stack img').remove();
    return $('#stack').append("<img class='card' src='/images/" + card.image + "'>");
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
  socket.on('recieve cards', function(data) {
    var card, image, _i, _len, _ref, _results;
    notice("You got " + data.cards.length + " cards");
    _ref = data.cards;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      card = _ref[_i];
      image = $("<img id='card_" + card.id + "' class='card' src='/images/" + card.image + "'>");
      image.click(handleCardClick);
      _results.push($("#cards").append(image));
    }
    return _results;
  });
  socket.on('joined game', function(data) {
    return notice("Player " + data.player.name + " joined the game");
  });
  socket.on('card played', function(data) {
    notice("Player " + data.player.name + " played " + data.card.name);
    return putOnStack(data.card);
  });
  socket.on('card accepted', function(data) {
    notice("You played the " + data.card.name);
    $("#cards #card_" + data.card.id).remove();
    return putOnStack(data.card);
  });
  socket.on('card rejected', function() {
    return notice("That card is not allowed to be played");
  });
  socket.on('reset', function(data) {
    var button;
    notice("Player " + data.player.name + " has reset the game");
    $("#stack img").remove();
    $("#cards img").remove();
    $("#cards button").remove();
    button = $("<button id='join' class='btn primary'>Join Game!</button>");
    $("#cards").append(button);
    return button.click(handleJoinClick);
  });
  jQuery(function() {
    $('#chat').click(handleChatClick);
    $('#join').click(handleJoinClick);
    $('#reset').click(handleResetClick);
    $(window).click(focus);
    focus();
    return chooseName();
  });
}).call(this);
