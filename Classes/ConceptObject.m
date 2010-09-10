//
//  ConceptObject.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObject.h"


@implementation ConceptObject

@synthesize selected, delegate;

- (id)initWithFrame:(CGRect)frame {
	[super initWithFrame:frame];
//	[super init];
	self.userInteractionEnabled = YES;
    self.layer.borderWidth = 5;
    self.layer.cornerRadius = 12;
	
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
	deleteBox.hidden = YES;
	[self.layer addSublayer:deleteBox];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
										  initWithTarget:self action:@selector(handleObjectTapGesture:)];
	[self addGestureRecognizer:tapGesture];
	[tapGesture release];

	UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] 
											  initWithTarget:self action:@selector(handlePinchGesture:)];
	[self addGestureRecognizer:pinchGesture];
	[pinchGesture release];

	return self;
}

- (void)setSelected:(BOOL)isSelected {
	selected = isSelected;
	if (selected) {
		self.layer.borderColor = [[UIColor yellowColor] CGColor];
		deleteBox.hidden = NO;
	} else {
		self.layer.borderColor = self.layer.backgroundColor;
		deleteBox.hidden = YES;
	}

	[delegate conceptObject:self isSelected:selected];
}

- (void)layoutSubviews {
	FUNCTION_LOG();

	CGRect r;
	CGPoint pt;
	
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

}

#pragma mark Handling touches 

- (IBAction)handleObjectTapGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
	self.selected = !self.selected;
}

- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
	switch (sender.state) {
		case UIGestureRecognizerStatePossible:
		case UIGestureRecognizerStateBegan:
			pinchScale = sender.scale;
			break;
		case UIGestureRecognizerStateChanged:
			if (sender.scale > pinchScale) {
				CGRect bounds = self.bounds;
				bounds.size.height += 5;
				bounds.size.width += 5;
				self.bounds = bounds;
			} else {
				CGRect bounds = self.bounds;
				bounds.size.height -= 5;
				bounds.size.width -= 5;
				self.bounds = bounds;
			}
//			[self layoutContentsOf:hitLayer];
			break;
			
		default:
			break;
	}
	pinchScale = sender.scale;
	
}

@end
