//
//  ConceptObject.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObject.h"
#define BODY_DISPLAY_STRING_INDENT_X		10
#define BODY_DISPLAY_STRING_INDENT_Y		10


@implementation ConceptObject

@synthesize selected, myDelegate, concept, isActiveDropTarget, conceptObjectLabel;

+ (ConceptObject *)conceptObjectWithConcept:(Concept *)concept {
	CGRect r = CGRectMake([concept.originX intValue], [concept.originY intValue], [concept.width intValue], [concept.height intValue]);
	ConceptObject *newCO = [[ConceptObject alloc] initWithFrame:r];
	newCO.concept = concept;
	return newCO;
}
 
- (void)addDeleteButton {
	deleteButton = [CALayer layer];
	deleteButton.borderColor = [[UIColor clearColor] CGColor];
	deleteButton.backgroundColor = [[UIColor whiteColor] CGColor];
	//deleteButton.borderWidth = 5;
	//deleteButton.cornerRadius = 25;
	deleteButton.masksToBounds = YES;
	deleteButton.hidden = YES;
	UIImage *c = [UIImage imageNamed:@"delete.png"];
	deleteButton.contents = (id)c.CGImage;
	
	[deleteButton setValue:LAYER_NAME_DELETE forKey:LAYER_NAME];
	[self.layer addSublayer:deleteButton];
}

- (void)addSettingsButton {
	settingsButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] retain]; 
	[settingsButton setFrame:CGRectMake(200, 0, 50, 50)];

	[settingsButton addTarget:self action:@selector(doSettings:) forControlEvents:UIControlEventTouchUpInside];
 	settingsButton.enabled = YES;
	settingsButton.hidden = YES;
	settingsButton.userInteractionEnabled = YES;
	//settingsButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;

	[self.layer addSublayer:settingsButton.layer];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
//	[super init];
	self.userInteractionEnabled = YES;
    self.layer.borderWidth = 5;
    self.layer.cornerRadius = 12;
	self.layer.borderColor = [[UIColor clearColor] CGColor];
	self.layer.masksToBounds = YES;
	[self.layer setValue:LAYER_NAME_OBJECT forKey:LAYER_NAME];

	[self setFrame:frame];
	
	[self addDeleteButton];
	[self addSettingsButton];
	
	conceptObjectLabel = [[ConceptObjectLabel alloc] init];
	//conceptObjectLabel.	= concept.conceptObjectColorSet.titleBackgroundColor;
	[self.layer addSublayer:conceptObjectLabel];

	CGRect bodyDisplayStringFrame = CGRectMake(BODY_DISPLAY_STRING_INDENT_X, 
											   conceptObjectLabel.bounds.size.height, 
											   frame.size.width - BODY_DISPLAY_STRING_INDENT_X * 2, 
											   frame.size.height - conceptObjectLabel.bounds.size.height - BODY_DISPLAY_STRING_INDENT_Y);
	bodyDisplayString = [[UITextField alloc] initWithFrame:bodyDisplayStringFrame];
	bodyDisplayString.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	bodyDisplayString.backgroundColor = [UIColor clearColor];
	[self addSubview:bodyDisplayString];

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
	//FUNCTION_LOG(@"current bounds = (%@, %@) (%@, %@)", self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);

	return self;
}

- (void)setConcept:(Concept *)newConcept {
	concept = newConcept;

	self.backgroundColor = concept.conceptObjectColorSet.backgroundColor;
	conceptObjectLabel.borderColor		= concept.conceptObjectColorSet.titleBorderColor.CGColor; 
	conceptObjectLabel.backgroundColor	= concept.conceptObjectColorSet.titleBackgroundColor.CGColor;
	
	conceptObjectLabel.title = concept.title;
	[conceptObjectLabel setNeedsDisplay];

	bodyDisplayString.text = concept.bodyDisplayString;
	[bodyDisplayString setNeedsDisplay];
}

- (void)setSelected:(BOOL)isSelected {
	selected = isSelected;
	if (selected) {
		self.layer.borderColor = [[UIColor yellowColor] CGColor];
		deleteButton.hidden = NO;
		[bodyDisplayString becomeFirstResponder];
	} else {
		self.layer.borderColor = [[UIColor clearColor] CGColor];
		deleteButton.hidden = YES;
		[bodyDisplayString resignFirstResponder];
	}
	settingsButton.hidden = deleteButton.hidden;
 	settingsButton.enabled = ! settingsButton.hidden;

	[myDelegate conceptObject:self isSelected:selected];
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

- (void)addConceptObject:(ConceptObject *)newConceptObject {
	[self addSubview:newConceptObject];
	newConceptObject.concept.parentConcept = self.concept;
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
	deleteButton.bounds = r;
	deleteButton.anchorPoint = CGPointZero;
	
	pt = deleteButton.position;
	pt.x = self.bounds.size.width - deleteButton.bounds.size.width - 10;
	deleteButton.position = pt;
	deleteButton.backgroundColor = [[UIColor brownColor] CGColor];
	deleteButton.backgroundColor = deleteButton.borderColor;
	
	r = settingsButton.bounds;
	r.origin.x -= 50;
	settingsButton.bounds = r;
	FUNCTION_LOG(@"(%i, %i) (%i, %i)", r.origin.x, r.origin.y, r.size.width, r.size.height
				 );
//	settingsButton.layer.anchorPoint = CGPointZero;
//	pt = settingsButton.layer.position;
//	pt.x = self.bounds.size.width - deleteButton.bounds.size.width - 20 - settingsButton.bounds.size.width;

	[CATransaction commit];
}

#pragma mark Handling touches 

- (IBAction)handleObjectTapGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
	CGPoint viewPoint = [sender locationInView:self.superview];
	CALayer *hitLayer = [self.layer hitTest:viewPoint];
	
	NSString *layerName = (NSString *)[hitLayer valueForKey:LAYER_NAME];
	FUNCTION_LOG(@" (%i)tapped on %@ (%i)", self, layerName, hitLayer);
	
	if ([layerName isEqualToString:LAYER_NAME_TITLE]) {
		FUNCTION_LOG(@"Title tapped");
		self.selected = YES;
		conceptObjectTitleViewController = [[ConceptObjectTitleViewController alloc] initWithNibName:@"ConceptObjectTitleViewController" bundle:nil];
		conceptObjectTitleViewController.conceptObject = self;
		
		UIPopoverController *popover = [[[UIPopoverController alloc] 
										 initWithContentViewController:conceptObjectTitleViewController] retain];
		
		[popover presentPopoverFromRect:[hitLayer convertRect:hitLayer.bounds toLayer:self.layer]
								 inView:self 
			   permittedArrowDirections:UIPopoverArrowDirectionAny 
							   animated:YES];
		
		
	} else if ([layerName isEqualToString:LAYER_NAME_DELETE]) {
		FUNCTION_LOG(@"Delete tapped");
		self.selected = YES;
		NSString *msg = [[NSString alloc] initWithFormat:@"Are you sure you want to delete %@?", concept.title];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Item"
														message:msg
													   delegate:self 
											  cancelButtonTitle:@"No" 
											  otherButtonTitles:@"Yes", nil];
		[alert show];
		[alert release];
	} else if (hitLayer == settingsButton.layer || [settingsButton.layer containsPoint:viewPoint]) {
		FUNCTION_LOG(@"HIT SETTINGS");
	} else {
		self.selected = !self.selected;
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	FUNCTION_LOG(@"Chose item %i", buttonIndex);
	if (buttonIndex == 1) {
		[self removeFromSuperview];
		[[concept document] removeConceptsObject:self.concept];
		// TODO is a pointer to this ConceptObject being held still in ConceptMapView?
	}
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
			self.layer.superlayer.masksToBounds = NO;
			
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
			[myDelegate conceptObject:self isPanning:sender];
				
		}
			break;
		case UIGestureRecognizerStateEnded:
			//NSLog(@"UIGestureRecognizerStateEnded");
		{
			CGPoint where = dragLastPoint;
			
			self.layer.superlayer.masksToBounds = YES;
			self.layer.position = where;
			self.layer.zPosition = 0;
			self.layer.shadowColor = [UIColor clearColor].CGColor;
			[self.layer setValue:[NSNumber numberWithFloat:1.0f] forKeyPath:@"transform.scale"];
			
			CGRect rect = self.bounds;
			rect.origin.x = dragLastPoint.x;
			rect.origin.y = dragLastPoint.y;
			[concept setRect:self.frame];
			
			[myDelegate conceptObject:self panningEnded:sender];

		}

			break;				
	}
}

- (void)doSettings:(id)sender {
	FUNCTION_LOG(@"Do settings");
	conceptObjectSettingsViewController = [[ConceptObjectSettingsViewController alloc] initWithNibName:@"ConceptObjectSettingsViewController" bundle:nil];
	//conceptObjectSettingsViewController.conceptObject = self;
	UIPopoverController *popover = [[[UIPopoverController alloc] 
									 initWithContentViewController:conceptObjectSettingsViewController] retain];
	
	[popover presentPopoverFromRect:[settingsButton.layer convertRect:settingsButton.bounds  
													toLayer:self.layer]
							 inView:self 
		   permittedArrowDirections:UIPopoverArrowDirectionAny 
						   animated:YES];
}

@end

@implementation Concept(UserInterface)
- (ConceptObjectColorSet *)conceptObjectColorSet {
	ConceptObjectColorSet *newColorSet = [[ConceptObjectColorSet alloc] init];
	newColorSet.colorSchemeConstant = [self.colorSchemeConstant intValue];
	return newColorSet;
}

@end
