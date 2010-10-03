//
//  ConceptObjectColorSet.h
//  ConceptMap
//
//  Created by Preston Rohner on 9/23/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"

@interface ConceptObjectColorSet : NSObject {
	ColorSchemeConstant colorSchemeConstant;
	NSString *colorSchemeName;
	UIColor *borderColor;
	UIColor *backgroundColor;
	UIColor *foregroundColor;
	UIColor *titleBorderColor;
	UIColor *titleBackgroundColor;
	UIColor *titleForegroundColor;
}

@property (nonatomic) ColorSchemeConstant colorSchemeConstant;

@property (nonatomic, readonly) NSString *colorSchemeName;
@property (nonatomic, readonly) UIColor *borderColor;
@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) UIColor *foregroundColor;
@property (nonatomic, readonly) UIColor *titleBorderColor;
@property (nonatomic, readonly) UIColor *titleBackgroundColor;
@property (nonatomic, readonly) UIColor *titleForegroundColor;

+ (NSString *)colorToHexString:(UIColor *)color;

@end
