function RB_Submission_Graph_Add_Step()
{
	if($("div.step_holder").length == 10)
	{
		System_Alert_Error( "Setup Submission Graph", "The step graph is full.");
	}
	else
	{
		let blockerScreen = document.getElementById('blockerScreen');

		if(blockerScreen != null)
		{
			blockerScreen.style.display = '';
			blockerScreen.style.width=screen.width + "px";
			blockerScreen.style.height=screen.height + "px";
		}
		ShowAJAXWindowWithID('aAjaxBox', 300, 150);
			
		$.ajax(
		{ 
	   		url: "RB_Setup_Submission_Graph_AJAX.jsp?FORM_ACTION=ADD_STEP&rand="+new Date().getTime(), 
	      	cache: false, 
	      	success: function(data) 
	      	{ 
	      		$('#aAjaxBox').html(data); 
				$('#aAjaxBox').draggable({ handle: "#AjaxWinDragHandle" });
	     	} 
	   	});
	}
}

function RB_Submission_Graph_Add_Custom_Step()
{
	let blockerScreen = document.getElementById('blockerScreen');

	if(blockerScreen != null)
	{
		blockerScreen.style.display = '';
		blockerScreen.style.width=screen.width + "px";
		blockerScreen.style.height=screen.height + "px";
	}
	ShowAJAXWindowWithID('aAjaxBox', 400, 300);
		
	$.ajax(
	{ 
   		url: "RB_Setup_Submission_Graph_AJAX.jsp?FORM_ACTION=ADD_CUSTOM_STEP&rand="+new Date().getTime(), 
      	cache: false, 
      	success: function(data) 
      	{ 
      		$('#aAjaxBox').html(data); 
			$('#aAjaxBox').draggable({ handle: "#AjaxWinDragHandle" });
     	} 
   	});
}

function RB_Submission_Graph_Show_Button()
{		
	$.ajax(
	{ 
   		url: "RB_Setup_Submission_Graph_AJAX.jsp?FORM_ACTION=DISPLAY_BUTTON&rand="+new Date().getTime(), 
      	cache: false, 
      	success: function(data) 
      	{
      		$('#button_menu').html(data);
     	} 
   	});
}

function RB_Submission_Graph_Show_Step()
{
	$.ajax(
	{ 
   		url: "RB_Setup_Submission_Graph_AJAX.jsp?FORM_ACTION=DISPLAY_STEP&rand="+new Date().getTime(), 
      	cache: false, 
      	success: function(data) 
      	{
      		$("#main").html(data);
     	} 
   	});
}

function RB_Submission_Graph_Reset_Step()
{
	System_Confirm( "Reset All Step?", "Are you sure to reset all step to default?<br/>This will remove all your custom step.", RB_Submission_Graph_Reset_Step_Callback);
}

function RB_Submission_Graph_Reset_Step_Callback()
{
	$.ajax({ 
   		url: "RB_Setup_Submission_Graph_AJAX.jsp?FORM_ACTION=RESET_STEP&rand="+new Date().getTime(), 
      	cache: false, 
      	success: function() 
      	{
      		RB_Submission_Graph_Show_Step();
     	} 
   	});
}

function RB_Submission_Graph_Save()
{
	if($("div.step_holder").length < 10)
	{
		System_Alert_Error( "Setup Submission Graph", "The number of step is not correct!!!");
	}
	else
	{
		$.ajax({ 
	   		url: "RB_Setup_Submission_Graph_AJAX.jsp?FORM_ACTION=SAVE_GRAPH&rand="+new Date().getTime(), 
	      	cache: false, 
	      	success: function() 
	      	{
	      		location.reload();
	     	} 
	   	});
	}
}

function RB_Submission_Graph_Save_Predefined_Step()
{
	$.ajax({ 
   		url: "RB_Setup_Submission_Graph_AJAX.jsp?FORM_ACTION=SAVE_PREDEFINED_STEP&rand="+new Date().getTime(), 
   		type: 'POST',
      	cache: false, 
      	data: $('form').serialize(),
      	success: function()
      	{
      		Close_RB_Submission_Graph_Popup();
      		RB_Submission_Graph_Show_Step();
     	} 
   	});
}

function RB_Submission_Graph_Delete(ORDER, STEP_NAME)
{
	System_Confirm( "Delete Step?", "Are you sure to remove this step???", RB_Submission_Graph_Delete_Callback, ORDER, STEP_NAME);
}

function RB_Submission_Graph_Delete_Callback(ORDER, STEP_NAME)
{
	$.ajax({ 
   		url: "RB_Setup_Submission_Graph_AJAX.jsp", 
   		type: 'POST',
      	cache: false, 
      	data: "FORM_ACTION=DELETE_STEP&ORDER="+ORDER+"&STEP_NAME="+STEP_NAME+"&rand="+new Date().getTime(),
      	success: function() 
      	{
      		RB_Submission_Graph_Show_Step();
     	} 
   	});
}

function Close_RB_Submission_Graph_Popup()
{
	let blockerScreen = document.getElementById('blockerScreen');

	if(blockerScreen != null)
	{
		blockerScreen.style.display = 'none';
	}
    
	HideAJAXWindowWithID('aAjaxBox','aAjaxBackFrame');
	
	$('#aAjaxBox').empty();
}


function Handle_Back_Click()
{
	$('a.back_button').prop('onclick', '').off('click');
	$('a.back_button').on('click', function() {
		$.ajax(
		{ 
	   		url: "RB_Setup_Submission_Graph_AJAX.jsp?FORM_ACTION=BACK_NAVIGATE&rand="+new Date().getTime(), 
	      	cache: false, 
	      	success: function() 
	      	{
	      		navigate_back();
	     	} 
	   	});
	});
}