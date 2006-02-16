/*
 *  libfb - FreeBASIC's runtime library
 *	Copyright (C) 2004-2005 Andre V. T. Vicentini (av1ctor@yahoo.com.br) and others.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

/*
 *	dev_file - file device
 *
 * chng: jul/2005 written [mjs]
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include "fb.h"
#include "fb_rterr.h"

static FB_FILE_HOOKS fb_hooks_dev_cons = {
    fb_DevFileEof,
    fb_DevStdIoClose,
    NULL,
    NULL,
    NULL,
    NULL,
    fb_DevFileWrite,
    fb_DevFileWriteWstr,
    NULL,
    NULL,
    NULL,
    NULL
};

int fb_DevConsOpen( struct _FB_FILE *handle, const char *filename, size_t filename_len )
{
    /* only output or append modes allowed (as in QB) */
    switch ( handle->mode )
    {
	case FB_FILE_MODE_OUTPUT:
	case FB_FILE_MODE_APPEND:
		break;

	default:
		return fb_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL );
    }

    FB_LOCK();

    handle->hooks = &fb_hooks_dev_cons;

    if ( handle->access == FB_FILE_ACCESS_ANY)
        handle->access = FB_FILE_ACCESS_WRITE;

	handle->opaque = stdout;
    handle->type = FB_FILE_TYPE_PIPE;

    FB_UNLOCK();

	return fb_ErrorSetNum( FB_RTERROR_OK );
}
