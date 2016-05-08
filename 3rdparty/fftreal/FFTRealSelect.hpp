/*****************************************************************************

        FFTRealSelect.hpp
        By Laurent de Soras

--- Legal stuff ---

This program is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it
and/or modify it under the terms of the Do What The Fuck You Want
To Public License, Version 2, as published by Sam Hocevar. See
http://sam.zoy.org/wtfpl/COPYING for more details.

*Tab=3***********************************************************************/



#if defined (FFTRealSelect_CURRENT_CODEHEADER)
	#error Recursive inclusion of FFTRealSelect code header.
#endif
#define	FFTRealSelect_CURRENT_CODEHEADER

#if ! defined (FFTRealSelect_CODEHEADER_INCLUDED)
#define	FFTRealSelect_CODEHEADER_INCLUDED




/*\\\ PUBLIC \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/



template <int P>
float *	FFTRealSelect <P>::sel_bin (float *e_ptr, float *o_ptr)
{
	return (o_ptr);
}



template <>
inline float *	FFTRealSelect <0>::sel_bin (float *e_ptr, float *o_ptr)
{
	return (e_ptr);
}





#endif	// FFTRealSelect_CODEHEADER_INCLUDED

#undef FFTRealSelect_CURRENT_CODEHEADER



/*\\\ EOF \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\*/
