//
//  ConceptObject.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObject.h"


@implementation ConceptObject

@synthesize selected, delegate, concept, isActiveDropTarget;

+ (ConceptObject *)conceptObjectWithConcept:(Concept *)concept {
	CGRect r = CGRectMake([concept.originX intValue], [concept.originY intValue], [concept.width intValue], [concept.height intValue]);
	ConceptObject *newCO = [[ConceptObject alloc] initWithFrame:r];
	newCO.concept = concept;
	return newCO;
}
 
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
//	[super init];
	self.userInteractionEnabled = YES;
    self.layer.borderWidth = 5;
    self.layer.cornerRadius = 12;
	self.layer.borderColor = [[UIColor clearColor] CGColor];
	self.layer.masksToBounds = YES;

	
	[self setFrame:frame];
	
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
	
	conceptObjectLabel = [[ConceptObjectLabel alloc] init];
	[self.layer addSublayer:conceptObjectLabel];
	
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
	FUNCTION_LOG(@"current bounds = (%@, %@) (%@, %@)", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);

	return self;
}

- (void)setConcept:(Concept *)newConcept {
	concept = newConcept;
	conceptObjectLabel.title = concept.title;
	[conceptObjectLabel setNeedsDisplay];
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

- (void)setIsActiveDropTarget:(BOOL)isTarget {
	if (isTarget) {
		FUNCTION_LOG(@"YES");
		self.layer.borderColor = [[UIColor redColor] CGColor];
	} else {
		FUNCTION_LOG(@"NO");
		self.layer.borderColor = [[UIColor clearColor] CGColor];
	}
}

- (void)layoutSubviews {
	//FUNCTION_LOG(@"current bounds = (%@, %@) (%@, %@)", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);

	[CATransaction flush];
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
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

	[CATransaction commit];
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
			holdSelected = self.selected;
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
		case UIGestureRecognizerStateEnded:
			[concept setRect:self.frame];
			self.selected = holdSelected;
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
			//NSLog(@"UIGestureRecognizerStateBegan");
			self.layer.zPosition = 2;
			self.layer.shadowOffset = CGSizeMake(15.0f, 15.0f);
			self.layer.shadowRadius = self.layer.cornerRadius;
			self.layer.shadowOpacity = 0.35f;
			self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
			[self.layer setValue:[NSNumber numberWithFloat:1.10f] forKeyPath:@"transform.scale"];
			break;
		case UIGestureRecognizerStateChanged:
		{
			//NSLog(@"UIGestureRecognizerStateChanged");
			
			CGPoint viewPoint = [sender locationInView:self];
			dragLastPoint = [self convertPoint:viewPoint toView:self.superview];

			[CATransaction flush];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			self.layer.position = dragLastPoint;
			[CATransaction commit];
			[delegate conceptObject:self isPanning:sender];
				
		}
			break;
		case UIGestureRecognizerStateEnded:
			//NSLog(@"UIGestureRecognizerStateEnded");
		{
			CGPoint where = dragLastPoint;
			
			self.layer.position = where;
			self.layer.zPosition = 0;
			self.layer.shadowColor = [UIColor clearColor].CGColor;
			[self.layer setValue:[NSNumber numberWithFloat:1.0f] forKeyPath:@"transform.scale"];
			
			CGRect rect = self.bounds;
			rect.origin.x = dragLastPoint.x;
			rect.origin.y = dragLastPoint.y;
			[concept setRect:self.frame];
			
			[delegate conceptObject:self panningEnded:sender];

		}

			break;				
	}
}
@end
