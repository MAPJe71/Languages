(: 
    https://notepad-plus-plus.org/community/topic/17543/xquery-udl
    
    1) using "proper" double and single quotes, \x22 and \x27 resp.
    2) added indentation
:)

module namespace page = 'http://basex.org/examples/web-page';
declare
    %rest:path("/save1item")
    %rest:POST("{$message}")
(:  %rest:form-param("amount", "{$message}", "(no data)") :)
    %rest:header-param("User-Agent", "{$agent}")
function page:hello-postman(
    $message as xs:string,
    $agent as xs:string*
) as xs:string { $message };
(:
  as element(response) { 
    <response type=‘form’>
        <message>{ $message }</message>
        <user-agent>{ $agent }</user-agent>
    </response> 
  }; 
:)