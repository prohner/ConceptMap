//
//  ConceptObjectColorSet.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/23/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectColorSet.h"
#import "Utility.h"

#define OPAQUE_HEXCOLOR(c) [UIColor colorWithRed:	((c>>16)&0xFF)/255.0 \
										   green:	((c>>8)&0xFF)/255.0 \
											blue:	 (c&0xFF)/255.0 \
										   alpha:	1.0]; 


@implementation ConceptObjectColorSet
@synthesize colorSchemeConstant, borderColor, backgroundColor, foregroundColor, titleBorderColor, titleBackgroundColor, titleForegroundColor;

- (void)setColorSchemeConstant:(ColorSchemeConstant)newScheme {
	switch (newScheme) {
		// From http://colorschemedesigner.com/
		case ColorSchemeConstantBlue:
			// based on 0x0B61A4
			borderColor				= OPAQUE_HEXCOLOR(0xffbf00);	// leftmost, middle
			backgroundColor			= OPAQUE_HEXCOLOR(0x033e6b);	// middle, top
			foregroundColor			= OPAQUE_HEXCOLOR(0x66a3d2);	// right, top
			titleBorderColor		= OPAQUE_HEXCOLOR(0xa62f00);	// middle, bottom
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0xa67c00);	// middle, middle
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xffdc73);	// middle, right
			break;
		case ColorSchemeConstantPurple:
			// based on 0xB70094
			borderColor				= OPAQUE_HEXCOLOR(0x4dde00);	// leftmost, middle
			backgroundColor			= OPAQUE_HEXCOLOR(0x770060);	// middle, top
			foregroundColor			= OPAQUE_HEXCOLOR(0xdb62c4);	// right, top
			titleBorderColor		= OPAQUE_HEXCOLOR(0xa69c00);	// middle, bottom
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0x329000);	// middle, middle
			titleForegroundColor	= OPAQUE_HEXCOLOR(0x99ee6b);	// middle, right
			break;
		default:
			// based on 0x0B61A4
			borderColor				= OPAQUE_HEXCOLOR(0xffbf00);
			backgroundColor			= OPAQUE_HEXCOLOR(0x033e6b);
			foregroundColor			= OPAQUE_HEXCOLOR(0x66a3d2);
			titleBorderColor		= OPAQUE_HEXCOLOR(0xa62f00);
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0xa67c00);
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xffdc73);
			break;
	}
}

@end
