/* REXX ================================================================ */
/*                                                                       */
/* Name      : makeXML.rex                                               */
/* Datum     : 18.05.2010                                                */
/*                                                                       */
/* Autor     : Gert Massheimer                                           */
/* eMail     : Delta@DeltaOS.de                                          */
/*                                                                       */
/* Funktion  : Aus Rexx.api eine Rexx.xml erstellen.                     */
/* Function  : Create from Rexx.api a Rexx.xml file.                     */
/*                                                                       */
/* Syntax    : Open Object Rexx                                          */
/*                                                                       */
/* ===================================================================== */

  apiFile = 'Rexx.api' -- input file
  xmlFile = 'Rexx.xml' -- output file

  apiFile = .Stream~New(apiFile)
    xmlFile = .Stream~New(xmlFile)
      xmlFile~LineOut('<?xml version="1.0" encoding="Windows-1252" standalone="yes" ?>')
      xmlFile~LineOut('<NotepadPlus>')
      xmlFile~LineOut('  <AutoComplete>')
      xmlArraySize = apiFile~Lines
      xmlArray = .Array~New(apiFile~Lines)
      Do i = 1 to apiFile~Lines
        KeyWord = apiFile~LineIn~Strip -- stripping leading and trailing spaces
        xmlArray~Put(KeyWord , i)
      End
      xmlArray~Sort -- sorting the keywords in alphabetically order
      Do k over xmlArray
        xmlFile~LineOut('    <KeyWord name="' || k || '" />')
      End
      xmlFile~LineOut('  </AutoComplete>')
      xmlFile~LineOut('</NotepadPlus>')
    xmlFile~Close
  apiFile~Close
  
Exit
