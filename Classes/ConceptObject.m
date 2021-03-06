//
//  ConceptObject.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/8/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObject.h"
#import "ConceptMapView.h"

#define BODY_DISPLAY_STRING_INDENT_X		10
#define BODY_DISPLAY_STRING_INDENT_Y		10
#define DELETE_BUTTON_SIZE					20
#define OUTER_LAYER_BORDER_WIDTH			3

@implementation ConceptObject

@synthesize selected, isConnecting, myDelegate, concept, isActiveDropTarget, conceptObjectLabel, childConceptObjects, rootLayer;
@synthesize conceptMapView, popover;

+ (ConceptObject *)conceptObjectWithConcept:(Concept *)concept {
	CGRect r = CGRectMake([concept.originX intValue], [concept.originY intValue], [concept.width intValue], [concept.height intValue]);
	ConceptObject *newCO = [[ConceptObject alloc] initWithFrame:r];
	newCO.concept = concept;
	[concept setConceptObject:newCO];
	newCO.layer.contents = 	(id)[[UIImage imageWithData:concept.backgroundImage] CGImage];

	return newCO;
}
 
- (void)addDeleteButton {
	deleteButton = [[ConceptObjectDeleteButton alloc] init];	
	[deleteButton setValue:LAYER_NAME_DELETE forKey:LAYER_NAME];
	deleteButton.conceptObject = self;
	deleteButton.hidden = YES;
	[self.layer addSublayer:deleteButton];
}

- (void)addConnectButton {
//	connectButton = [[ConceptObjectConnectButton alloc] init];	
//	[connectButton setValue:LAYER_NAME_CONNECT forKey:LAYER_NAME];
//	connectButton.conceptObject = self;
//	connectButton.hidden = YES;
//	[self.layer addSublayer:connectButton];
}

- (void)addSettingsButton {
	settingsButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] retain]; 
	[settingsButton setFrame:CGRectMake(200, 0, 50, 50)];

	[settingsButton addTarget:self action:@selector(doSettings:) forControlEvents:UIControlEventTouchUpInside];
 	settingsButton.enabled = YES;
	settingsButton.hidden = YES;
	settingsButton.userInteractionEnabled = YES;
//	settingsButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;// | UIViewAutoresizingFlexibleBottomMargin;

	[self.layer addSublayer:settingsButton.layer];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	self.childConceptObjects = [[NSArray alloc] init];
	
	self.layer.anchorPoint = CGPointMake(0.0f, 0.0f);

	self.userInteractionEnabled = YES;
    self.layer.borderWidth = OUTER_LAYER_BORDER_WIDTH;
    self.layer.cornerRadius = 12;
	self.layer.borderColor = [[UIColor clearColor] CGColor];
	self.layer.masksToBounds = YES;
	[self.layer setValue:LAYER_NAME_OBJECT forKey:LAYER_NAME];

	[self setFrame:frame];
	
	[self addSettingsButton];
	[self addConnectButton];
	[self addDeleteButton];
	
	conceptObjectLabel = [[ConceptObjectLabel alloc] init];
	conceptObjectLabel.conceptObject = self;
	[self.layer addSublayer:conceptObjectLabel];

	CGRect bodyDisplayStringFrame = CGRectMake(BODY_DISPLAY_STRING_INDENT_X, 
											   DELETE_BUTTON_SIZE + OUTER_LAYER_BORDER_WIDTH + 1, 
											   frame.size.width - BODY_DISPLAY_STRING_INDENT_X * 2, 
											   frame.size.height - DELETE_BUTTON_SIZE + OUTER_LAYER_BORDER_WIDTH + 1 - BODY_DISPLAY_STRING_INDENT_Y);
	bodyDisplayString = [[UITextView alloc] initWithFrame:bodyDisplayStringFrame];
	bodyDisplayString.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	bodyDisplayString.backgroundColor = [UIColor clearColor];
//	bodyDisplayString.backgroundColor = [UIColor lightGrayColor];
	bodyDisplayString.userInteractionEnabled = NO;
	bodyDisplayString.delegate = self;
	bodyDisplayString.contentInset = UIEdgeInsetsMake(-8, -8, 0, 0);
	//[bodyDisplayString addTarget:self action:@selector(bodyDisplayStringBecameActive:) forControlEvents:UIControlEventEditingDidBegin];
	[self addSubview:bodyDisplayString];

	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
										  initWithTarget:self action:@selector(handleObjectTapGesture:)];
	[self addGestureRecognizer:tapGesture];
	[tapGesture release];

	UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]
												initWithTarget:self 
												action:@selector(handleObjectDoubleTapGesture:)];
	doubleTapGesture.numberOfTapsRequired = 2;
	[self addGestureRecognizer:doubleTapGesture];
	[doubleTapGesture release];
	
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

- (void)setBodyDisplayStringFont {
	UIFont *f = [UIFont fontWithName:concept.fontName size:[concept.fontSize intValue]];
//	FUNCTION_LOG(@"Font size = %@, font name = %@", concept.fontSize, concept.fontName);
	
	bodyDisplayString.font = f;
	
}

- (void)setBodyDisplayStringText:(NSString *)newText {
	bodyDisplayString.text = newText;
	concept.bodyDisplayString = newText;
	
}

- (void)viewDidUnload {
	self.childConceptObjects = nil;
	self.popover = nil;
}


- (void) dealloc {
	[deleteButton release];
	[connectButton release];
	[conceptObjectLabel release];
	[popover release];
	[super dealloc];
}

- (void)bodyDisplayStringBecameActive:(id)sender {
	FUNCTION_LOG(@"%i", sender);
	if (self.selected) {
		[bodyDisplayString becomeFirstResponder];
	} else {
		[bodyDisplayString resignFirstResponder];
		self.selected = YES;
	}
}

- (void)setConcept:(Concept *)newConcept {
	concept = newConcept;

	conceptObjectLabel.title = concept.title;
	[conceptObjectLabel setNeedsDisplay];

	bodyDisplayString.text = concept.bodyDisplayString;
	[self setBodyDisplayStringFont];
	[bodyDisplayString setNeedsDisplay];
	
	[deleteButton setNeedsDisplay];
	[connectButton setNeedsDisplay];
}

- (void)manageSelectedAttributes {
	if (selected) {
		self.layer.borderColor = [[UIColor yellowColor] CGColor];
		deleteButton.hidden = NO;
		CGRect labelFrame = conceptObjectLabel.frame;
		labelFrame.origin.y = self.layer.borderWidth;
		self.layer.zPosition = 5;

		[conceptObjectLabel setFrame:labelFrame];
	} else {
		// self.layer.borderColor = self.concept.conceptObjectColorSet.borderColor.CGColor;
		self.layer.borderColor = [[UIColor clearColor] CGColor];
		deleteButton.hidden = YES;
		self.layer.zPosition = 0;
		bodyDisplayString.userInteractionEnabled = NO;
		
		CGRect labelFrame = conceptObjectLabel.frame;
		labelFrame.origin.y = 0;

		[conceptObjectLabel setFrame:labelFrame];
	}
	settingsButton.hidden = deleteButton.hidden;
	connectButton.hidden = deleteButton.hidden;
 	settingsButton.enabled = ! settingsButton.hidden;
	
	[myDelegate conceptObject:self isSelected:selected];
	[self setNeedsLayout];
}

- (void)setSelected:(BOOL)isSelected {
	selected = isSelected;
	FUNCTION_LOG(@"I am z==%i, and selected==%i", self.layer.zPosition, isSelected);
	[self manageSelectedAttributes];
}

- (void)setIsConnecting:(BOOL)newIsConnecting {
	isConnecting = newIsConnecting;
	[self manageSelectedAttributes];
	if (isConnecting) {
		self.layer.borderColor = [[UIColor greenColor] CGColor];
		[myDelegate conceptObject:self connecting:YES];
	} else {
		self.selected = NO;
		[self manageSelectedAttributes];
	}

}

- (void)setIsActiveDropTarget:(BOOL)isTarget {
	if (isTarget) {
		//FUNCTION_LOG(@"YES");
		self.layer.borderColor = [[UIColor redColor] CGColor];
	} else {
		//FUNCTION_LOG(@"NO");
		self.layer.borderColor = [[UIColor clearColor] CGColor];
	}
}

- (void)addConceptObject:(ConceptObject *)newConceptObject {
	[self addSubview:newConceptObject];
	[self.concept addConcept:newConceptObject.concept];
	newConceptObject.concept.parentConcept = self.concept;
}

- (void)removeConceptObject:(ConceptObject *)newConceptObject {
	[newConceptObject removeFromSuperview];
	[self.concept removeConceptsObject:newConceptObject.concept];
	newConceptObject.concept.parentConcept = nil;
}

- (void)removeFromParentConceptObject {
	[self removeFromSuperview];
	[self.concept.parentConcept removeConceptsObject:self.concept];
	self.concept.parentConcept = nil;
}

- (void)layoutSubviews {
//	FUNCTION_LOG(@"%@ current bounds = (%.0f, %.0f) (%.0f, %.0f)", concept.title, self.frame.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
	FUNCTION_LOG(@"%@ %i", concept.title, concept.conceptObjectColorSet.backgroundColor);
	self.backgroundColor				= concept.conceptObjectColorSet.backgroundColor;
	conceptObjectLabel.borderColor		= concept.conceptObjectColorSet.titleBorderColor.CGColor; 
	conceptObjectLabel.backgroundColor	= concept.conceptObjectColorSet.titleBackgroundColor.CGColor;
	
	bodyDisplayString.textColor			= concept.conceptObjectColorSet.foregroundColor;
	
	[CATransaction flush];
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	deleteButton.position = CGPointMake(15, 15);
	CGFloat rightSideOfLabel = conceptObjectLabel.frame.origin.x + conceptObjectLabel.frame.size.width;
	CGFloat leftSideOfDelete = self.bounds.size.width - DELETE_BUTTON_SIZE - self.layer.borderWidth;
	if (leftSideOfDelete < rightSideOfLabel + DELETE_BUTTON_SIZE) {
		leftSideOfDelete = rightSideOfLabel + DELETE_BUTTON_SIZE;
	}

	deleteButton.frame = CGRectMake(leftSideOfDelete, self.layer.borderWidth, DELETE_BUTTON_SIZE, DELETE_BUTTON_SIZE);

	CGFloat settingsX = rightSideOfLabel + ((leftSideOfDelete - rightSideOfLabel) / 2) - (settingsButton.frame.size.width / 2);
	//CGFloat settingsX = rightSideOfLabel + 10;
	if (settingsX < rightSideOfLabel) {
		settingsX = rightSideOfLabel;
	}
	settingsButton.frame = CGRectMake(settingsX, self.layer.borderWidth, DELETE_BUTTON_SIZE, DELETE_BUTTON_SIZE);

	CGFloat rightSizeOfSettings = settingsX + DELETE_BUTTON_SIZE;
	CGFloat connectX = rightSizeOfSettings + ((leftSideOfDelete - rightSizeOfSettings) / 2) - (connectButton.frame.size.width / 2);
	connectButton.frame = CGRectMake(connectX, self.layer.borderWidth, DELETE_BUTTON_SIZE, DELETE_BUTTON_SIZE);
	
	[CATransaction commit];
}

- (void)setConceptColorScheme:(ColorSchemeConstant)newColor {
	concept.colorSchemeConstant = [NSNumber numberWithInt:newColor];
	[deleteButton setNeedsDisplay];
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

- (void)setConceptSize:(CGSize)newSize {
	concept.width = [NSNumber numberWithFloat:newSize.width];
	concept.height = [NSNumber numberWithFloat:newSize.height];
	
	CGRect bounds = self.bounds;
	bounds.size = newSize;

	CGPoint savedPosition = self.layer.position;
	CGPoint adjustedPosition = self.layer.position;
	adjustedPosition.x = adjustedPosition.x / 2;
	adjustedPosition.y = adjustedPosition.x / 2;
	CGPoint savedAnchorPoint = self.layer.anchorPoint;
	self.layer.anchorPoint = CGPointMake(0, 0);
	self.layer.position = adjustedPosition;
	self.bounds = bounds;
	self.layer.position = savedPosition;
	self.layer.anchorPoint = savedAnchorPoint;
	

}

#pragma mark Handling touches 

- (IBAction)handleObjectTapGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
	if (sender.state == UIGestureRecognizerStateEnded) {
		if ([myDelegate conceptObject:self connected:YES]) {
			return;
		}
		
		CGPoint viewPoint = [sender locationInView:self.superview];
		CALayer *hitLayer = [self.layer hitTest:viewPoint];
		
		NSString *layerName = (NSString *)[hitLayer valueForKey:LAYER_NAME];
		FUNCTION_LOG(@" (%i)tapped on %@ (%i)", self, layerName, hitLayer);
		
		if ([layerName isEqualToString:LAYER_NAME_TITLE]) {
			FUNCTION_LOG(@"Title tapped");
			self.selected = YES;
			conceptObjectTitleViewController = [[ConceptObjectTitleViewController alloc] initWithNibName:@"ConceptObjectTitleViewController" bundle:nil];
			conceptObjectTitleViewController.conceptObject = self;
			
			self.popover = [[[UIPopoverController alloc] initWithContentViewController:conceptObjectTitleViewController] retain];
			
			[popover presentPopoverFromRect:[hitLayer convertRect:hitLayer.bounds toLayer:self.layer]
									 inView:self 
				   permittedArrowDirections:UIPopoverArrowDirectionAny 
								   animated:YES];
			
			
		} else if ([layerName isEqualToString:LAYER_NAME_DELETE]) {
			FUNCTION_LOG(@"Delete tapped");
			self.selected = YES;
			NSString *msg = [[NSString alloc] initWithFormat:NSLocalizedString(@"Are you sure you want to delete %@?", @""), concept.title];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Item", @"")
															message:msg
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"No", @"") 
												  otherButtonTitles:NSLocalizedString(@"Yes", @""), nil];
			[alert show];
			[alert release];
		} else if ([layerName isEqualToString:LAYER_NAME_CONNECT]) {
			FUNCTION_LOG(@"Connect Button Tapped");
			self.isConnecting = YES;
		} else if (hitLayer == settingsButton.layer || [settingsButton.layer containsPoint:viewPoint]) {
			FUNCTION_LOG(@"HIT SETTINGS");
		} else {
//			if (!self.selected) {
//				self.selected = YES;
//			}
			self.selected = !self.selected;
//			FUNCTION_LOG(@"Toggle selected to %i", self.selected);
		}
	}
}

- (void) handleObjectDoubleTapGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
	if (sender.state == UIGestureRecognizerStateEnded) {
		[self setSelected:YES];
		bodyDisplayString.userInteractionEnabled = YES;
		[bodyDisplayString becomeFirstResponder];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	FUNCTION_LOG(@"Chose item %i", buttonIndex);
	if (buttonIndex == 1) {
		[self removeFromSuperview];
		[self.concept removeConceptAndConnections:self.concept];
		[conceptMapView.conceptObjectConnections removeConnectionsToAndFrom:self];
		[conceptMapView setNeedsDisplay];
		[conceptMapView setNeedsLayout];
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
			[conceptMapView.conceptObjectConnections.layer setNeedsDisplay];
			break;
		case UIGestureRecognizerStateEnded:
			[concept setRect:self.frame];
			self.selected = holdSelected;
			[self setNeedsLayout];
			[conceptMapView.conceptObjectConnections.layer setNeedsDisplay];
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
			[self setLayerTreeFrom:self.layer toMasksToBounds:NO];
			
			self.layer.zPosition = 2;
			self.layer.shadowOffset = CGSizeMake(15.0f, 15.0f);
			self.layer.shadowRadius = self.layer.cornerRadius;
			self.layer.shadowOpacity = 0.35f;
			self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
			//[self.layer setValue:[NSNumber numberWithFloat:1.10f] forKeyPath:@"transform.scale"];
			
			break;
		case UIGestureRecognizerStateChanged:
		{
			//NSLog(@"UIGestureRecognizerStateChanged");
			
			CGPoint viewPoint = [sender locationInView:self];
			dragLastPoint = [self convertPoint:viewPoint toView:self.superview];
			dragLastPoint.x -= [self.concept.width floatValue] / 2;
			dragLastPoint.y -= [self.concept.height floatValue] / 2;

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
			
			[self setLayerTreeFrom:self.layer toMasksToBounds:YES];
			self.layer.position = where;
			self.layer.zPosition = 0;
			self.layer.shadowColor = [UIColor clearColor].CGColor;
			[self.layer setValue:[NSNumber numberWithFloat:1.0f] forKeyPath:@"transform.scale"];
			
//			CGRect rect = self.bounds;
//			rect.origin.x = dragLastPoint.x;
//			rect.origin.y = dragLastPoint.y;
//			LOG_CONCEPTOBJECT(self);
//			[concept setRect:self.frame];
//			LOG_CONCEPTOBJECT(self);
			
			[myDelegate conceptObject:self panningEnded:sender];

		}

			break;				
	}
}

- (void)setLayerTreeFrom:(CALayer *)layer toMasksToBounds:(BOOL)newValue {
	while (layer.superlayer != nil) {
		//if ([layer.superlayer isKindOfClass:[ConceptObject class]]) {
			layer.superlayer.masksToBounds = newValue;
		//}
		layer = layer.superlayer;
	}
}

- (void)doSettings:(id)sender {
	FUNCTION_LOG(@"");
//	self.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
	conceptObjectSettingsViewController = [[ConceptObjectSettingsViewController alloc] initWithNibName:@"ConceptObjectSettingsViewController" bundle:nil];
	conceptObjectSettingsViewController.conceptObject = self;
	
	//ConceptMapView *v = (ConceptMapView *)self.superview;
	conceptObjectSettingsViewController.conceptObjectConnections = self.conceptMapView.conceptObjectConnections;
	
	UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:conceptObjectSettingsViewController];

	self.popover = [[[UIPopoverController alloc] initWithContentViewController:navCtrl] retain];
	conceptObjectSettingsViewController.popover = popover;
	
	[popover presentPopoverFromRect:[settingsButton.layer convertRect:settingsButton.bounds  
													toLayer:self.layer]
							 inView:self 
		   permittedArrowDirections:UIPopoverArrowDirectionAny 
						   animated:YES];
	[conceptObjectSettingsViewController release];
	[navCtrl release];
}

#pragma mark UITextFieldDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self bodyDisplayStringBecameActive:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	concept.bodyDisplayString = textView.text;
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	concept.bodyDisplayString = textView.text;
}

#pragma mark UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	FUNCTION_LOG();
//	self.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
	[popoverController release];
}

@end

@implementation Concept(UserInterface)
- (ConceptObjectColorSet *)conceptObjectColorSet {
	ConceptObjectColorSet *newColorSet = [[[ConceptObjectColorSet alloc] init] autorelease];
	newColorSet.colorSchemeConstant = [self.colorSchemeConstant intValue];
	return newColorSet;
}

@end
