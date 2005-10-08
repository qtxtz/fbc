''	FreeBASIC - 32-bit BASIC Compiler.
''	Copyright (C) 2004-2005 Andre Victor T. Vicentini (av1ctor@yahoo.com.br)
''
''	This program is free software; you can redistribute it and/or modify
''	it under the terms of the GNU General Public License as published by
''	the Free Software Foundation; either version 2 of the License, or
''	(at your option) any later version.
''
''	This program is distributed in the hope that it will be useful,
''	but WITHOUT ANY WARRANTY; without even the implied warranty of
''	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
''	GNU General Public License for more details.
''
''	You should have received a copy of the GNU General Public License
''	along with this program; if not, write to the Free Software
''	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA.


'' atom constants and literals parsing
''
'' chng: sep/2004 written [v1ctor]

option explicit
option escape

#include once "inc\fb.bi"
#include once "inc\fbint.bi"
#include once "inc\parser.bi"
#include once "inc\ast.bi"

'':::::
'' Constant       = ID .
''
function cConstant( byref constexpr as ASTNODE ptr ) as integer static
	dim as FBSYMBOL ptr s
	dim as integer typ

	function = FALSE

	s = symbFindByClass( lexGetSymbol( ), FB_SYMBCLASS_CONST )
	if( s <> NULL ) then

  		typ = symbGetType( s )
  		if( irGetDataClass( typ ) = IR_DATACLASS_STRING ) then

			constexpr = astNewVAR( symbGetConstValStr( s ), NULL, 0, IR_DATATYPE_FIXSTR )

  		else
  			select case as const typ
  			case IR_DATATYPE_ENUM
  				constexpr = astNewENUM( symbGetConstValInt( s ), symbGetSubType( s ) )

  			case IR_DATATYPE_LONGINT, IR_DATATYPE_ULONGINT
  				constexpr = astNewCONST64( symbGetConstValLong( s ), typ )

  			case IR_DATATYPE_SINGLE, IR_DATATYPE_DOUBLE
  				constexpr = astNewCONSTf( symbGetConstValFloat( s ), typ )

  			case else
  				constexpr = astNewCONSTi( symbGetConstValInt( s ), typ, symbGetSubType( s ) )

  			end select
  		end if

  		lexSkipToken( )
  		function = TRUE
  	end if

end function

'':::::
''Literal		  = NUM_LITERAL | STR_LITERAL .
''
function cLiteral( byref litexpr as ASTNODE ptr ) as integer
	dim as FBSYMBOL ptr tc
	dim as integer typ

	function = FALSE

	select case lexGetClass( )
	case FB_TKCLASS_NUMLITERAL
  		typ = lexGetType( )
  		select case as const typ

  		case IR_DATATYPE_LONGINT
			litexpr = astNewCONST64( vallng( *lexGetText( ) ), typ )

		case IR_DATATYPE_ULONGINT
			litexpr = astNewCONST64( valulng( *lexGetText( ) ), typ )

  		case IR_DATATYPE_SINGLE, IR_DATATYPE_DOUBLE
			litexpr = astNewCONSTf( val( *lexGetText( ) ), typ )

		case IR_DATATYPE_UINT
			litexpr = astNewCONSTi( valuint( *lexGetText( ) ), typ )

		case else
			litexpr = astNewCONSTi( valint( *lexGetText( ) ), typ )
  		end select

  		lexSkipToken( )
  		function = TRUE

  	case FB_TKCLASS_STRLITERAL
		tc = hAllocStringConst( *lexGetText( ), lexGetTextLen( ) )
		litexpr = astNewVAR( tc, NULL, 0, IR_DATATYPE_FIXSTR )

		lexSkipToken( )
        function = TRUE
  	end select

end function

