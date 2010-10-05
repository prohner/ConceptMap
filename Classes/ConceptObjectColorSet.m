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
@synthesize colorSchemeName;


- (void)setColorSchemeConstant:(ColorSchemeConstant)newScheme {
	switch (newScheme) {
		// From http://colorschemedesigner.com/
		case ColorSchemeConstantBlue:
			// based on 0x0B61A4
			colorSchemeName			= @"Blue";
			borderColor				= OPAQUE_HEXCOLOR(0xffbf00);	// leftmost, middle
			backgroundColor			= OPAQUE_HEXCOLOR(0x033e6b);	// middle, top
			foregroundColor			= OPAQUE_HEXCOLOR(0x66a3d2);	// right, top
			titleBorderColor		= OPAQUE_HEXCOLOR(0xa62f00);	// middle, bottom
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0xa67c00);	// middle, middle
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xffdc73);	// middle, right
			break;
		case ColorSchemeConstantPurple:
			// based on 0xB70094
			colorSchemeName			= @"Purple";
			borderColor				= OPAQUE_HEXCOLOR(0x4dde00);	// leftmost, middle
			backgroundColor			= OPAQUE_HEXCOLOR(0x770060);	// middle, top
			foregroundColor			= OPAQUE_HEXCOLOR(0xdb62c4);	// right, top
			titleBorderColor		= OPAQUE_HEXCOLOR(0xa69c00);	// middle, bottom
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0x329000);	// middle, middle
			titleForegroundColor	= OPAQUE_HEXCOLOR(0x99ee6b);	// middle, right
			break;
		case ColorSchemeConstantYellow:
			// based on 0xffde00
			colorSchemeName			= @"Yellow";
			borderColor				= OPAQUE_HEXCOLOR(0x8805a8);	// leftmost, middle
			backgroundColor			= OPAQUE_HEXCOLOR(0xa69000);	// middle, top
			foregroundColor			= OPAQUE_HEXCOLOR(0xffed73);	// right, top
			titleBorderColor		= OPAQUE_HEXCOLOR(0x071871);	// middle, bottom
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0x58026d);	// middle, middle
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xbd63d4);	// middle, right
			break;
		case ColorSchemeConstantGreen:
			// based on 0x14d100
			colorSchemeName			= @"Green";
			borderColor				= OPAQUE_HEXCOLOR(0xff6f00);	// leftmost, middle
			backgroundColor			= OPAQUE_HEXCOLOR(0x0d8800);	// middle, top
			foregroundColor			= OPAQUE_HEXCOLOR(0x74e868);	// right, top
			titleBorderColor		= OPAQUE_HEXCOLOR(0x83004f);	// middle, bottom
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0xa64800);	// middle, middle
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xffb073);	// middle, right
			break;
		case ColorSchemeConstantLightGreen:
			// http://www.colorsontheweb.com/colorwizard.asp
			colorSchemeName			= @"Light Green";
			borderColor				= OPAQUE_HEXCOLOR(0x07ce58);	// leftmost, middle
			backgroundColor			= OPAQUE_HEXCOLOR(0x75faab);	// left top
			foregroundColor			= OPAQUE_HEXCOLOR(0xb7b7b7);	// right, top
			titleBorderColor		= OPAQUE_HEXCOLOR(0xfffeff);	// middle, bottom
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0x07ce58);	// middle, middle
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xfffeff);	// middle, right
			break;
		case ColorSchemeConstantLightBlue:
			// http://www.colorsontheweb.com/colorwizard.asp
			colorSchemeName			= @"Light Blue";
			borderColor				= OPAQUE_HEXCOLOR(0x08aee6);	// center top
			backgroundColor			= OPAQUE_HEXCOLOR(0x8ddffb);	// left top
			foregroundColor			= OPAQUE_HEXCOLOR(0xffffff);	// right top
			titleBorderColor		= OPAQUE_HEXCOLOR(0xffffff);	// right top
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0x08aee6);	// middle top
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xc4c4c4);	// bottom
			break;
		case ColorSchemeConstantLightBrown:
			// http://www.colorsontheweb.com/colorwizard.asp
			colorSchemeName			= @"Salmon";
			borderColor				= OPAQUE_HEXCOLOR(0x853d35);	// center top
			backgroundColor			= OPAQUE_HEXCOLOR(0xce8d86);	// left top
			foregroundColor			= OPAQUE_HEXCOLOR(0xfaf3f2);	// right top
			titleBorderColor		= OPAQUE_HEXCOLOR(0xfaf3f2);	// right top
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0x853d35);	// middle top
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xaaaaaa);	// bottom
			break;
		default:
			// based on 0x0B61A4
			colorSchemeName			= @"Blue";
			borderColor				= OPAQUE_HEXCOLOR(0xffbf00);
			backgroundColor			= OPAQUE_HEXCOLOR(0x033e6b);
			foregroundColor			= OPAQUE_HEXCOLOR(0x66a3d2);
			titleBorderColor		= OPAQUE_HEXCOLOR(0xa62f00);
			titleBackgroundColor	= OPAQUE_HEXCOLOR(0xa67c00);
			titleForegroundColor	= OPAQUE_HEXCOLOR(0xffdc73);
			break;
	}
}

+ (NSString *)colorToHexString:(UIColor *)color {
	const CGFloat *c = CGColorGetComponents(color.CGColor);
	CGFloat r = c[0];
	CGFloat g = c[1];
	CGFloat b = c[2];

	return [NSString stringWithFormat:@"%02X%02X%02X",
			(int)(r * 255), (int)(g * 255), (int)(b * 255)];
}

@end
