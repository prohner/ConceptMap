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
	self.layer.borderColor = [[UIColor clearColor] CGColor];
	
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

	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
										  initWithTarget:self 
										  action:@selector(handlePanGesture:)];
	[self addGestureRecognizer:panGesture];
	[panGesture release];

	return self;
}

- (void)setSelected:(BOOL)isSelected {
	selected = isSelected;
	if (selected) {
		self.layer.borderColor = [[UIColor yellowColor] CGColor];
		deleteBox.hidden = NO;
	} else {
		self.layer.borderColor = [[UIColor clearColor] CGColor];
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

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender {
	switch (sender.state) {
		case UIGestureRecognizerStatePossible:
		case UIGestureRecognizerStateBegan:
			self.layer.zPosition = 2;
			self.layer.shadowOffset = CGSizeMake(15.0f, 15.0f);
			self.layer.shadowRadius = self.layer.cornerRadius;
			self.layer.shadowOpacity = 0.35f;
			self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
			[self.layer setValue:[NSNumber numberWithFloat:1.10f] forKeyPath:@"transform.scale"];
			break;
		case UIGestureRecognizerStateChanged:
		{
			
			CGPoint viewPoint = [sender locationInView:self];
			dragLastPoint = [self convertPoint:viewPoint toView:self.superview];

			[CATransaction flush];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			self.layer.position = dragLastPoint;
			[CATransaction commit];
				
		}
			break;
		case UIGestureRecognizerStateEnded:
			NSLog(@"UIGestureRecognizerStateBegan 3");
			CGPoint where = dragLastPoint;
			
			self.layer.position = where;
			self.layer.zPosition = 0;
			self.layer.shadowColor = [UIColor clearColor].CGColor;
			[self.layer setValue:[NSNumber numberWithFloat:1.0f] forKeyPath:@"transform.scale"];
			break;				
	}
}
@end
