
# BNF Syntax

The following elements define the BNF syntax.

```
<AnyAction>             ::= <GmmiFileOpenAction>
                            | <GmmiPrevScreenAction>
                            | <GmmiHomeScreenAction>
                            | <GmmiFileCloseAction>
                            | <GmmiExecAction>
                            | <GmmiAbsoluteSetpointAction>
                            | <GmmiInvokeDispMethodAction>
                            | <GmmiRelativeSetpointAction>
                            | <GmmiRampSetpointAction>
                            | <GmmiVariableSetpointAction>
                            | <GmmiToggleSetpointAction>
                            | <GmmiInvokeScriptAction>
                            | <GmmiVariableAssignAction>
                            | <GmmiPrintScreenAction>

<AnyAttributeAnim>      ::= <GmmiFillAnim>
                            | <GmmiExprValueAnnun>
                            | <GmmiDefaultAnnun>
                            | <GmmiExprAnnun>
                            | <GmmiValueAnim>
                            | <GmmiVisibilityAnim>

<AnyEventList>          ::= <KeyDownEventList>
                            | <KeyUpEventList>
                            | <OleEventList>
                            | <WhileKeyDownEventList>
                            | <TimedEventList>
                            | <ExprEventList>

<AnyObject>             ::= <GmmiLineObject>
                            | <GmmiRectShapeObject>
                            | <GmmiEllipseShapeObject>
                            | <GmmiTextObject>
                            | <GmmiGroupObject>
                            | <GmmiOleObject>
                            | <GmmiTextButtonObject>
                            | <GmmiArcObject>
                            | <GmmiFAContainerObject>
                            | <GmmiFAFrameObject>
```
    Note: a <GmmiFAFrameObject> can only appear in a <GmmiFAContainerObject>

```
<AnyPositionAnim>       ::= <GmmiHorizMoveAnim>
                            | <GmmiVertMoveAnim>
                            | <GmmiRotateAnim>
                            | <GmmiHorizScaleAnim>
                            | <GmmiVertScaleAnim>

<AnySingleEvent>        ::= <GmmiMouseUpEvent>
                            | <GmmiMouseDownEvent>
                            | <GmmiWhileMouseDownEvent>
                            | <GmmiScreenOpenEvent>
                            | <GmmiScreenCloseEvent>

<AttributeAnimationTable>
                        ::= "(" GmmiOptionTable
                                {<AnyAttributeAnim>}+ ")"

<EventOptionTable>      ::= "(" GmmiOptionTable
                                { <AnySingleEvent> }*
                                { <AnyEventList> }* ")"


<ExecCond>              ::= "(" ExecCond <expression.string>
                                <message.string> ")"


<ExprEventList>         ::= "(" GmmiOptionTable
                                { <GmmiExprHighEvent> | <GmmiExprUpdateEvent> }+
                            ")"

<FillMode>              ::= <mode.number>
```
    Where _mode_ is one of:
        0 NoFill
        1 From Bottom
        2 From Top
        3 From Left
        4 From Right

```
<GmmiAbsoluteSetpointAction>
                        ::= "(" GmmiAbsoluteSetpointAction
                                <GmmiSetpointAction> <PointValue> ")"

<GmmiAction>            ::= <flags.number>
```
    Valid _flags_ are:
        0x01 Confirm

```
<GmmiActionAnim>        ::= <GmmiExprAnim> <flags.number>
                                <ExecCond>
```
    Valid _flags_ are:
        0x02 Has Action (slider setpoint or in-place edit setpoint)
        0x04 Confirmed

```
<GmmiActionList>        ::= "(" GmmiActionList { <AnyAction> }* ")"

<GmmiAnnunOptionTable>  ::= "(" GmmiOptionTable
                                [<GmmiColorAnnunAttr>]
                                [<GmmiTextAnnunAttr>]
                                [<GmmiBlinkAnnunAttr>]
                                [<GmmiInteriorAnnunAttr>]
                                [<GmmiBorderAnnunAttr>]
                                [<GmmiFontAnnunAttr>]")"

<GmmiArcObject>         ::= "(" GmmiArcObject
                                <GmmiGraphicObject> <GRArc> ")"

<GmmiBackdrop>          ::= "(" GmmiBackdrop
                                <border.GRBorderAttr>
                                <interior.GRInteriorAttr> ")"

<GmmiBlink>             ::= "(" GmmiBlink <rate.number>
                                <interior.GRInteriorAttr>
                                <fillInterior.GRInteriorAttr>
                                <border.GRBorderAttr> ")"

<GmmiBlinkAnnunAttr>    ::= "(" GmmiBlinkAnnunAttr ")"

<GmmiBorderAnnunAttr>   ::= "(" GmmiBorderAnnunAttr
                                <flags.number> <line.GRBorderAttr> ")"
```
    Valid _flags_ are:
        0x0001 Ignore line style
        0x0002 Ignore line color
        0x0004 Ignore line width

```
<GmmiButtonObject>      ::= <GmmiGraphicObject>

<GmmiColorAnnunAttr>    ::= "(" GmmiColorAnnunAttr
                                <color.GRColorAttr> ")"

<GmmiContainer>         ::= "(" GmmiContainerObject
                                <GmmiObject>
                                "("
                                    GmmiObjectPtrList
                                    { <AnyObject> }*
                                ")" <flags.number>
                                [ <overrideInterior.GRInteriorAttr> ]
                                [ <overrideBorder.GRBorderAttr> ]
                                [ <overrideFont.GRFontAttr> ]
                                <GmmiBackdrop>
                            ")"

<GmmiDefaultAnnun>      ::= "(" GmmiDefaultAnnun
                                <pointID.string> <element.number> <type.number>
                            ")"
```
    Where _type_ is 0 for Boolean points and 1 for numeric points.

```
<GmmiDocument>          ::= "(" GmmiDocumentObject
                                <GmmiContainer>
                            ")"

<GmmiEllipseShapeObject>
                        ::= "(" GmmiEllipseShapeObject
                                <GmmiGraphicObject>
                                <GRSimpleRect>
                            ")"

<GmmiEvent>             ::= "(" GmmiEvent
                                <actionFlags.number>
                                ( <procedureName.string> | <GmmiInvokeScriptAction> )
                                <userParameter.string>
                            ")"
```
    Valid _actionFlags_ are:
        1 Call procedure name
        2 Invoke script

```
<GmmiExecAction>        ::= "(" GmmiExecAction <GmmiAction>
                                <flags.number>
                                <command.string>
                                <directory.string>
                                <arguments.string>
                                <confirmMsg.string>
                            ")"
```
    Valid _flags_ are:
        0x01 Minimize

```
<GmmiExpr>              ::= "(" GmmiExpr <expression.string> ")"

<GmmiExprAnim>          ::= "(" GmmiExprAnim <flags.number>
                                [ <expr.string> ]
                                [ <minValue.number> <maxValue.number> ]
                            ")"
```
    Valid _flags_ are:
        0x01 Use configured limits (determines if limits appear)
        0x02 Has expression (determines if expression appears)

```
<GmmiExprAnnun>         ::= "(" GmmiExprAnnun
                                <count.number>
                                { <GmmiExprAnnunElement> }*
                            ")"
```
    There must be exactly _count_ <GmmiExprAnnunElement> entries.

```
<GmmiExprAnnunElement>  ::= "(" GmmiExprAnnunElement
                                <GmmiExprAnim>
                                <GmmiAnnunOptionTable> ")"

<GmmiExprEvent>         ::= "(" GmmiExprEvent <GmmiEvent>
                                <expr.GmmiExpr> ")"

<GmmiExprHighEvent>     ::= "(" GmmiExprHightEvent
                                <GmmiExprEvent> ")"

<GmmiExprUpdateEvent>   ::= "(" GmmiExprUpdateEvent
                                <GmmiExprEvent> ")"

<GmmiExprValueAnnun>    ::= "(" GmmiExprValueAnnun
                                <GmmiExprAnim> ")"

<GmmiFAContainerObject> ::= "(" GmmiFAContainerObject
                                <GmmiContainer> <FillMode>
                                <fillInterior.GRInteriorAttr> ")"
```
    Note: A GmmiFAContainerObject only contains GmmiFAFrameObjects

```
<GmmiFAFrameObject>     ::= "(" GmmiFAFrameObject
                                <GmmiContainer>
                                <frameSelector.GmmiExpr> <FillMode>
                                <fillInterior.GRInteriorAttr> ")"

<GmmiFileCloseAction>   ::= "(" GmmiFileCloseAction
                                <GmmiAction> ")"

<GmmiFileOpenAction>    ::= "(" GmmiFileOpenAction
                                <GmmiAction> <pathname.string>
                                <flags.number> <position.Point>
                                <zoom.number> <project.string> ")"
```
    Valid _flags_ are
        0x01 Open screen action (rather than overlay screen action)
        0x02 Captive

```
<GmmiFillAnim>          ::= "(" GmmiFillAnim <GmmiExprAnim> ")"

<GmmiFontAnnunAttr>     ::= "(" GmmiFontAnnunAttr <flags.number>
                                <font.GRFontAttr> ")"
```
    Valid _flags_ are:
        0x0001 Ignore font name
        0x0002 Ignore font style
        0x0004 Ignore font size
        0x0008 Ignore font strikeout
        0x0010 Ignore font underline
        0x0020 Ignore font script

```
<GmmiGraphicObject>     ::= <GmmiObject>

<GmmiGroupObject>       ::= "(" GmmiGroupObject
                                <GmmiContainer> <FillMode>
                                <fillInterior.GRInteriorAttr> ")"

<GmmiHomeScreenAction>  ::= "(" GmmiHomeScreenAction
                                <GmmiAction> ")"

<GmmiHorizMoveAnim>     ::= "(" GmmiHorizMoveAnim
                                <GmmiMoveAnim> ")"

<GmmiHorizScaleAnim>    ::= "(" GmmiHorizScaleAnim
                                <GmmiScaleAnim> ")"

<GmmiInteriorAnnunAttr> ::= "(" GmmiInteriorAnnunAttr
                                <flags.number> <fill.GRInteriorAttr> ")"
```
    Valid _flags_ are:
        0x0001 Ignore fill style
        0x0002 Ignore fill color1
        0x0004 Ignore fill color2
        0x0008 Ignore fill pattern
        0x0010 Ignore whether one color or two color gradient shading
        0x0020 Ignore number of gradient shades
        0x0040 Ignore gradient shade style
        0x0080 Ignore gradient shade variant

```
<GmmiInvokeDispMethodAction>
                        ::= "(" GmmiInvokeDispMethodAction
                                <GmmiAction> <objectName.string>
                                <methodName.string>
                                <GmmiParameterBlock> ")"

<GmmiInvokeScriptAction>
                        ::= "(" GmmiInvokeScriptAction
                                <GmmiAction> <objectName.string>
                                <scriptEntryPointName.string>
                                <GmmiParameterBlock> ")"

<GmmiKeyDownEvent>      ::= "(" GmmiKeyDownEvent
                                <GmmiKeyEvent> ")"

<GmmiKeyEvent>          ::= "(" GmmiKeyEvent <GmmiEvent>
                                <keyCode.number> ")"

<GmmiKeyUpEvent>        ::= "(" GmmiKeyUpEvent
                                <GmmiKeyEvent> ")"

<GmmiLineObject>        ::= "(" GmmiLineObject
                                <GmmiGraphicObject> <GRPolyLine> ")"


<GmmiMethodParam>       ::= <paramType.number> <GmmiExpr>
```
    Where _paramType_ is one of:
        0 Empty parameter
        1 Input parameter
        2 Output parameter: A set-point will be performed on a point.
        3 Method result: A set-point will be performed on a point.

```
<GmmiMouseDownEvent>    ::= "(" GmmiMouseDownEvent
                                <GmmiEvent> ")"

<GmmiMouseUpEvent>      ::= "(" GmmiMouseUpEvent
                                <GmmiEvent> ")"

<GmmiMoveAnim>          ::= <GmmiActionAnim> <offset.number>
```
    Valid _flags_ are:
        0x02 Slider Animation
        0x04 Confirm Silder

```
<GmmiObject>            ::= "("
                                GmmiObject <name.string> <flags.number> [ <GmmiBlink> ]
                                <Help>
                                [ <ToplevelDocumentPO> ]
                                <RootOptionTable>
                                <GmmiTabOrder>
                            ")"
```
    The <ToplevelDocumentPO> data must be present if and only if this object is a
    toplevel document.

```
<GmmiOleEvent>          ::= "(" GmmiOleEvent <GmmiEvent>
                                <eventName.string> ")"

<GmmiOleObject>         ::= "(" GmmiOleObject
                                <GmmiGraphicObject>
                                <GROleGraphic> ")"

<GmmiParameterBlock>    ::= "(" GmmiParameterBlock
                                <countParams.number>
                                {<GmmiMethodParam>}* ")"

<GmmiPoint>             ::= "(" GmmiPoint <pointID.string>
                                <PointAttr> ")"

<GmmiPointMap>          ::= "(" GmmiPointMap { <GmmiPoint> }* ")"

<GmmiPrevScreenAction>  ::= "(" GmmiPrevScreenAction
                                <GmmiAction> ")"

<GmmiPrintScreenAction> ::= "(" GmmiPrintScreenAction
                                <GmmiAction> ")"

<GmmiProcedure>         ::= "(" GmmiProcedure <name.string>
                                <description.string>
                                <procFlags.number> <confMsg.string>
                                <successMsg.string>
                                <failureMsg.string>
                                <execFlags.number> <GmmiActionList>
                            ")"
```
    Where _procFlags_ is:
        0x01 Halt On Error
    Where _execFlags_ is one of:
        0x01 Always Confirm
        0x02 Never Confirm

```
<GmmiProcedureMap>      ::= "(" GmmiProcedureMap
                                { <GmmiProcedure> }* ")"

<GmmiRampSetpointAction>
                        ::= "(" GmmiRampSetpointAction
                                <GmmiRelativeSetpointAction>
                                <altValue.number> <flags.number> ")"
```
    Valid _flags_ are:
        0x01 Allow direct edit of value

```
<GmmiRectShapeObject>   ::= "(" GmmiRectShapeObject
                                <GmmiGraphicObject>
                                <GRSimpleRect> ")"

<GmmiRelativeSetpointAction>
                        ::= "(" GmmiRelativeSetpointAction
                                <GmmiSetpointAction> <value.number> ")"

<GmmiRotateAnim>        ::= "(" GmmiRotateAnim
                                <GmmiExprAnim> <centerOffset.Point>
                                <minAngle.number>
                                <maxAngle.number> ")"

<GmmiScaleAnim>         ::= <GmmiExprAnim>
                            <scaleOrigin.number>
                            <scaleFactor.number>
```
    Where _ScaleOrigin_ is one of:
        0 bottom for vertical, left for horizontal
        1 center
        2 top for vertical, right for horizontal

```
<GmmiScreenOpenEvent>   ::= "(" GmmiScreenOpenEvent
                                <GmmiEvent> ")"

<GmmiScreenCloseEvent>  ::= "(" GmmiScreenCloseEvent
                                <GmmiEvent> ")"

<GmmiScript>            ::= "(" GmmiScript <string> ")"

<GmmiSetpointAction>    ::= "(" GmmiSetpointAction
                                <GmmiAction> <pointID.string>
                                <element.number> <flags.number> ")"
```
    Valid _flags_ are:
        0x01 Point not validated
    Valid _element_ numbers are:
        -1 Non -array points and text strings
        0 through n-1 Index of an array element to be set, where the array has n
        elements. 0 is the first element and n-1 is the last element of the
        array.

```
<GmmiTabOrder>          ::= "(" GmmiTabOrder <number> ")"

<GmmiTextAnnunAttr>     ::= "(" GmmiTextAnnunAttr
                                <text.string> ")"

<GmmiTextButtonObject>  ::= "(" GmmiTextButtonObject
                                <GmmiButtonObject> <GRTextButton> ")"

<GmmiTextObject>        ::= "(" GmmiTextObject
                                <GmmiGraphicObject> <GRText> ")"

<GmmiTimedEvent>        ::= "(" GmmiTimedEvent <GmmiEvent>
                                <eventFrequencyMS.number> ")"

<GmmiToggleSetpointAction>
                        ::= "(" GmmiToggleSetpointAction
                                <GmmiSetpointAction> ")"

<GmmiValueAnim>         ::= "(" GmmiValueAnim
                                <GmmiExprAnim> <format.string>
                                <formatType.number> ")"
```
    Where _format_ is a printf() style format string and
    where _formatType_ is one of:
        1 No format
        2 Configured
        3 Custom
        4 General
        5 Integer
        6 Text
        7 Real

```
<GmmiVariableAssignAction>
                        ::= "(" GmmiVariableAssignAction
                                <GmmiAction> <variableID.string>
                                <value.string> <flags.number> ")"
```
    Valid _flags_ are
        0x01 Prompt for the variable value.

```
<GmmiVariableMap >      ::= "(" GmmiVariables
                                {<GmmiVariables>}* ")"

<GmmiVariables>         ::= "(" GmmiVariables
                                <variableID.string> <value.string> ")"

<GmmiVariableSetpointAction>
                        ::= "(" GmmiVariableSetpointAction
                                <GmmiSetpointAction> ")"

<GmmiVertMoveAnim>      ::= "(" GmmiVertMoveAnim
                                <GmmiMoveAnim> ")"

<GmmiVertScaleAnim>     ::= "(" GmmiVertScaleAnim
                                <GmmiScaleAnim> ")"

<GmmiVisibilityAnim>    ::= "(" GmmiVisibilityAnim
                                <GmmiExprAnim> ")"

<GmmiWhileKeyDownEvent> ::= "(" GmmiWhileKeyDownEvent
                                <GmmiKeyEvent>
                                <eventFrequencyMS.number> ")"

<GmmiWhileMouseDownEvent> ::= "(" GmmiWhileMouseDownEvent
                                <GmmiEvent>
                                <eventFrequencyMS.number> ")"

<GRArc>                 ::= <GRShape> <GRArcDim>

<GRArcDim>              ::= <GRRectShapeDim>
                            <startAngle.number>
                            <endAngle.number>

<GRAttrib>              ::= <Empty>

<GRBitmapButton>        ::= <GRButton>
                            <bitmapButtonFlags.number>
                            <bitmapSize.size>

<GRBorderAttr>          ::= "(" Border <GRColorObjAttr>
                                <width.number> <lineType.number>
                                <lineEndStyle.number> ")"

<GRBorderRes>           ::= <GRObjRes> <GRBorderAttr>

<GRBoundGraphic>        ::= <GRGraphic>

<GRButton>              ::= <GRBoundGraphic>
                            <face.GRInteriorRes>
                            <buttonFlags.number>

<GRColorAttr>           ::= "(" Color "0" ")"
                                | "(" Color "1" <rgb.number> ")"
                                | "(" Color "2" <index.number> ")"
                                | "(" Color "3" <systemColor.number>
                                ")"

<GRColorObjAttr>        ::= <GRObjAttr> <GRColorAttr>

<GRFontAttr>            ::= "(" Font <GRObjAttr>
                            <fontName.string> <angle.number>
                            <height.number> <weight.number>
                            <fontAttr.number> ")"

<GRFontRes>             ::= <GRObjRes> <GRFontAttr>

<GRGraphic>             ::= "(" Extents <extent.Rect>
                                <rawExtent.Rect> ")"

<GRInteriorAttr>        ::= "(" Interior <GRColorObjAttr>
                                <color2.GRColorAttr>
                                <fillStyle.number>
                                [<gradientColors.number>
                                <gradientShades.number>] ")"
```
    The _GRColorAttr_ contained in the GRColorObjAttr is used by the solid, patterned
    and gradient fill styles.
    _color2_ is used only by the patterned and gradient fill styles.

```
<GRInteriorRes>         ::= <GRObjRes> <GRInteriorAttr>

<GRObjAttr>             ::= <Empty>

<GRObjRes>              ::= <Empty>

<GROleClientItem>       ::= "("GROleClientItem
                            <itemNumber.number> ")"

<GROleControl>          ::= "("GROleControl <OlePropBag> ")"

<GROleGraphic>          ::= <GRShape> <itemScale.Scaler> <Rect>
                                "("GROleClientItem
                                <itemNumber.number> ")"

<GROleGraphicData>      ::= <GROleControl> | <GROleClientItem>

<GRPolyLine>            ::= <GRShape> <PointArray>
                                <lineFlags.number> "("Arrow
                                <arrowWidth0.number>
                                <arrowLength0.number>
                                <arrowStyle0.number> ")" "("Arrow
                                <arrowWidth1.number>
                                <arrowLength1.number>
                                <arrowStyle1.number> ")"

<GRRectShapeDim>        ::= "(" Size <aDim.number>
                                <bDim.number> ")" <center.Point>
                            <angle.number> <xShear.number>
                            <yShear.number>

<GRResource>            ::= <Empty>

<GRShape>               ::= <GRBoundGraphic>
                            <GRShapeResources>

<GRShapeResources>      ::= <GRBorderRes>
                            <interior.GRInteriorRes>
                            <fillInterior.GRInteriorRes>
                            <fillMode.number>
                            <percentFill.number>

<GRSimpeRect>           ::= <GRShape> <GRRectShapeDim>

<GRText>                ::= <GRGraphic> <GRTextAttributes>

<GRTextAttributes>      ::= <GRFontAttr> <GRInteriorRes>
                            <GRBorderRes> <textAlign.number>
                            <textAnchor.Point> <text.string>

<GRTextButton>          ::= <GRButton> <GRText>

<Help>                  ::= "(" Help <contextIDExpr.string>
                                <text.string> <file.string> ")"

<HexBlob>               ::= "(" HexBlob { <string> }* ")"

<KeyDownEventList>      ::= "(" GmmiOptionArray {
                                <GmmiKeyDownEvent> }+ ")"

<KeyUpEventList>        ::= "(" GmmiOptionArray {
                                <GmmiKeyUpEvent> }+ ")"

<OleCurrency>           ::= "(" OleCurrency
                                <currencyValue.string> ")"

<OleDate>               ::= "(" OleDate <dateValue.string> ")"

<OleEventList>          ::= "(" GmmiOptionArray {
                                <GmmiOleEvent> }+ ")"

<OleI64>                ::= "(" OleI64 <I64Value.string> ")"

<OleItemData>           ::= "(" GROleClientItem
                                <itemNumber.number> <HexBlob> ")"

<OlePropBag>            ::= "(" OlePropBag <objectCLSID.guid>
                                {<PropElement>}* ")"

<OlePropStream>         ::= "(" OlePropStream
                                <objectCLSID.guid> <HexBlob> ")"

<OleSafeAray>           ::= "(" OleSafeArray
                                <elementType.number>
                                <dimensionCount.number> {"("
                                OleArrayBound
                                <lowerBound.number>
                                <elementCount.number> ")" }+ {
                                <PropElementData> }+ ")"

<OleU64>                ::= "(" OleU64 <U64Value.string> ")"

<Point>                 ::= "(" Point <x.number> <y.number> ")"

<PointArray>            ::= "(" PointArray {<Point>}* ")"

<PointAttr>             ::= 255
                            | <type.number> <length.number><elements.number>

<PointValue>            ::= <value.number> | <value.string>

<PositionAnimationTable> ::= "(" GmmiOptionTable
                                {<AnyPositionAnim>}+ ")"

<PropElement>           ::= <propName.string>
                            <PropElementData>

<PropElementData>       ::= <numValue.number>
                            | <strValue.string>
                            | <OlePropBag>
                            | <OlePropStream>
                            | <OleCurrency>
                            | <OleDate>
                            | <OleI64>
                            | <OleU64>
                            | <OleSafeArray>

<Rect>                  ::=     "(" Rect <left.number> <top.number>
                            <right.number> <bottom.number> ")"

<RootOptionTable>       ::=   "(" Empty ")"
                            | "(" GmmiOptionTable
                                [ <PositionAnimationTable> ]
                                [ <AttributeAnimationTable> ]
                                [ <EventOptionTable> ]
                                [ <GmmiScript> ]
                                [ <GmmiVariableMap> ]
                              ")"

<Scaler>                ::= <xNum.number> <yNum.number>
                            <xDen.number> <yDen.number>

<Size>                  ::= "(" Size <width.number>
                                <height.number> ")"

<TextFileFormat>        ::= "(" Version <number> ")" "("
                                DocumentSummary ")"
                                <ToplevelDocument> "{Newline}("
                                OleItems { <OleItemData> ")"

<TimedEventList>        ::= "(" GmmiOptionTable
                                {<GmmiTimedEvent>}+ ")"

<ToplevelDocument>      ::= "(" GmmiToplevelDocument
                                <GmmiDocument>
                                <initialPosition.Point> <Size>
                                <zoom.number> ")"

<ToplevelDocumentPO>    ::= <GmmiPointMap>
                            <ambientForeground.GRColorAttr>
                            <ambientBackground.GRColorAttr>
                            <ambientFont.GRFontAttr>
                            <GmmiProcedureMap>

<WhileKeyDownEventList> ::= "(" GmmiOptionArray {
                                <GmmiWhileKeyDownEvent> }+ ")"

<Bool>                  ::= <number>
```
    Note: Zero means false; non-zero means true

```
<Empty>                 ::=
```
    This non-terminal is used for emphasis to designate that nothing should appear.


### Token Syntax

Here is the modified BNF syntax for tokens. Tokens (except for <string>) may not
contain embedded whitespace.


```
<alpha-char>            ::= "A" through "Z" and "a" through "z"

    (?'ALPHA_CHAR'
        [A-Za-z]
    )

<digit>                 ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"

<exponent-char>         ::= "e" | "E" | "d" | "D"

<guid>                  ::= "{" xxxxxxxx "-" xxxx "-" xxxx "-" xxxx "-" xxxxxxxxxxxx "}"

```
                        where x == <hex-digit>

```
<hex-digit>             ::= <digit> | "A" | "B" | "C" | "D" | "E" | "F" | "a" | "b" | "c" | "d" | "e" | "f"

<mantissa>              ::=   { <digit> }+ [ "." { <digit> }* ]
                            | { <digit> }*   "." { <digit> }+

<named-char>            ::= One of the following characters:
                                Null                            (&h00)
                                Bell                            (&h07)
                                Backspace                       (&h08)
                                CharacterTabulation or Tab      (&h09)
                                LineFeed or NewLine             (&h0A)
                                LineTabulation                  (&h0B)
                                FormFeed                        (&h0C)
                                CarriageReturn or Return        (&h0D)
                                Escape                          (&h1B)
                                QuotationMark                   (&h3F)
                                LeftCurlyBracket or LeftBrace   (&h7B)
                                RightCurlyBracket or RightBrace (&h7D)
                                Delete                          (&h7F)

```
    Named characters use the ISO 1064 naming convention for characters.
    Convenience names for some characters are also defined.


```
<non-negative-integer>  ::= { <digit> }+
                            | "&H" { <hex-digit>   }+
                            | "&h" { <hex-digit>   }+
                            | "&O" { <octal-digit> }+
                            | "&o" { <octal-digit> }+

<number>                ::=   [ <sign> ] <non-negative-integer>
                            | [ <sign> ] <mantissa> [ <exponent-char> [ <sign> ] { <digit> }+ ]

<octal-digit>           ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7"

<sign>                  ::= "+" | "-"

<string>                ::= """ { <string-char> }* """
                            | <string> { "&" <string> }*

<string-char>           ::= any character except LineFeed (&h0A), "{", or """
                            | "{" <non-negative-integer> "}"
                            | "{" <named-char>           "}"

<symbol>                ::= <alpha-char> { <symbol-char> }*

<symbol-char>           ::= <alpha-char> <digit> "_"

<token>                 ::= "("
                            | ")"
                            | <guid>
                            | <number>
                            | <symbol>
                            | <string>
```
