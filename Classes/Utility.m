//
//  Utility.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "Utility.h"


@implementation Utility

static ColorSchemeConstant lastColorSchemeUsed = ColorSchemeConstantBlue;

+ (ColorSchemeConstant)nextColorScheme {
	if (lastColorSchemeUsed < ColorSchemeConstantMAX - 1) {
		lastColorSchemeUsed++;
	} else {
		lastColorSchemeUsed = ColorSchemeConstantBlue;
	}
	return lastColorSchemeUsed;
}

@end
