$(document).ready(function(){

  // =========== Input Field Listener with AJAX Callback ==============
    function FieldListener(entity){
      var t = this;

      this.typingTimer;               // Timer identifier
      this.doneTypingInterval = 500;  // Time in ms. e.g.; 5000 = 5secs        
      this.entity = entity;
      this.entityType = encodeURIComponent(this.entity.attr("name"));
      this.noticeSpan = this.entity.siblings("span");
      this.parentForm = entity.parents('form:first');
      this.context = this.parentForm.attr("name");

      entity.on("keyup", function(e){
        var code = (e.keyCode ? e.keyCode : e.which);
        // Unless keycode equates to tab or return, set timer function.
        if(code != (9 || 13)) { 
           t.setTimer();
        }
      });
    }
  
    FieldListener.prototype.setTimer = function(){
      var t = this;

      clearTimeout(this.typingTimer);
      
      // Display 'waiting' notice to user.
      this.noticeSpan.html('...')

      this.typingTimer = setTimeout(function(){t.doneTyping();},this.doneTypingInterval);
    }

    FieldListener.prototype.doneTyping = function(){
      var t = this;
      var post_data = this.parentForm.serialize();
      

      // Update password_confirmation if new_password is changed. 
      if(this.entityType == 'new_password'){
        // Update password_confirmation if it has a value.
        var confirmation_value = this.parentForm.find("input[name=password_confirmation]").val()
        if(confirmation_value){
          fieldListeners['password_confirmation'].doneTyping();
        }
        // Empty password_confirmation's notice span if new_password is empty and password_confirmation has no value.
        else if(!this.entity.val() && !confirmation_value){
          this.parentForm.find("input[name=password_confirmation]").siblings("span").empty();
        }
      }

      $.ajax({
        url: '/validate/'+this.context+'/'+this.entityType,
        type: "POST",
        data: post_data
      })
      .done(function(validationMessage){
        if(validationMessage){
          t.noticeSpan.html(validationMessage);
        }
        else{
          t.noticeSpan.empty();
        }
      })
      .fail(function(jqXHR, textStatus){
        t.noticeSpan.html("Something went wrong. Please try again.");
      });       
    }
    
    var fieldListeners = [];
    $(".update-user-info-field").each(function(){
        fieldListeners[$(this).attr("name")] = new FieldListener($(this));
    });
  // =========== /Input Field Listener with AJAX Callback =============

});