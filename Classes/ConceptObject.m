//
//  ConceptObject.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObject.h"


@implementation ConceptObject

@synthesize selected;


- (id)init {
	[super init];
    self.borderWidth = 5;
    self.cornerRadius = 12;
	
	CGRect r;
	CGPoint pt;

	deleteBox = [CATextLayer layer];
	deleteBox.borderColor = [[UIColor yellowColor] CGColor];
	deleteBox.backgroundColor = [[UIColor redColor] CGColor];
	deleteBox.borderWidth = 5;
	deleteBox.cornerRadius = 25;
	deleteBox.string = @"X";
	deleteBox.font = CGFontCreateWithFontName((CFStringRef)[UIFont boldSystemFontOfSize:25].fontName); 
	deleteBox.fontSize = 25;
	deleteBox.alignmentMode = kCAAlignmentCenter;
	deleteBox.foregroundColor = [[UIColor blackColor] CGColor];
	
	r = self.bounds;
	r.origin.x -= 5;
	r.origin.y -= 5;
	r.size.height = 40;
	r.size.width = 40;
	deleteBox.bounds = r;
	deleteBox.anchorPoint = CGPointZero;
	
	pt = deleteBox.position;
	pt.x = self.bounds.size.width - deleteBox.bounds.size.width - 10;
	deleteBox.position = pt;
	deleteBox.backgroundColor = [[UIColor brownColor] CGColor];
	deleteBox.backgroundColor = deleteBox.borderColor;

	deleteBox.hidden = YES;
	
	[self addSublayer:deleteBox];
	
	
	return self;
}

- (void)addToView:(UIView *)view {
	myContainingView = view;
	[view.layer addSublayer:self];

}

- (void)setSelected:(BOOL)isSelected {
	selected = isSelected;
	if (selected) {
		self.borderColor = [[UIColor yellowColor] CGColor];
		self.borderWidth = 8;
		
		CGPoint pt = deleteBox.position;
		pt.x = self.bounds.size.width - deleteBox.bounds.size.width - 10;
		deleteBox.position = pt;

		deleteBox.hidden = NO;
	} else {
		self.borderColor = [[UIColor blackColor] CGColor];
		self.borderWidth = 5;
		deleteBox.hidden = YES;
	}

}

@end
