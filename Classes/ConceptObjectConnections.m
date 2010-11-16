//
//  ConceptObjectConnections.m
//  ConceptMap
//
//  Created by Preston Rohner on 10/9/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "ConceptObjectConnections.h"
#import "Utility.h"
#import "Concept.h"
#import "ConceptObject.h"
#import "DataController.h"

#define degreesToRadians(angle)  (angle * M_PI / 180)
#define radiansToDegrees(angle)  (angle * 180 / M_PI)

@implementation ConceptObjectConnections

@synthesize connectionLabelViewController, myDelegate;

- (id) initWithFrame:(CGRect)r {
	[super initWithFrame:r];
	FUNCTION_LOG();
	
	connections = [[NSMutableDictionary alloc] init];

	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
										  initWithTarget:self action:@selector(handleObjectTapGesture:)];
	[self addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	return self;
}

- (IBAction)handleObjectTapGesture:(UITapGestureRecognizer *)sender {
	FUNCTION_LOG();
	if (sender.state == UIGestureRecognizerStateEnded) {
		CGPoint viewPoint = [sender locationInView:self];
		CALayer *hitLayer = [self.layer hitTest:viewPoint];
		FUNCTION_LOG(@"Tapped in layer: %@", [hitLayer valueForKey:LAYER_NAME]);
		if ([hitLayer valueForKey:LAYER_NAME] != nil) {
			self.connectionLabelViewController = [[ConnectionLabelViewController alloc] initWithNibName:@"ConnectionLabelViewController" bundle:nil];
			
			for (NSString *key in connections) {
				ConceptObjectConnection *cxn = (ConceptObjectConnection *)[connections valueForKey:key];
				if (cxn.layer == hitLayer) {
					connectionLabelViewController.connectedConcept = cxn.connectedConcept;
				}
			}
			
			UIPopoverController *popover = [[[UIPopoverController alloc] 
											 initWithContentViewController:connectionLabelViewController] retain];
			popover.delegate = self;
			
			[popover presentPopoverFromRect:[hitLayer convertRect:hitLayer.bounds toLayer:self.layer]
									 inView:self 
				   permittedArrowDirections:UIPopoverArrowDirectionAny 
								   animated:YES];
		} else {
			// If we're not handling the tap, then offer the delegate a chance
			[myDelegate handleObjectTapGesture:sender];
		}

	}
}


//- (void)drawInContext:(CGContextRef)context {
- (void)resetTheConnectionLabels {
	FUNCTION_LOG();
	for (NSString *key in connections) {
		ConceptObjectConnection *cxn = (ConceptObjectConnection *)[connections valueForKey:key];
		
		NSString *title = [[NSString alloc] initWithFormat:@"%@  ", cxn.connectionDescription];
		//		NSString *title = @"x";
		UIFont *font = [UIFont systemFontOfSize:12];
		CGSize size = [title sizeWithFont:font];
		
		[cxn.layer setBounds:CGRectMake(0, 0, size.width, size.height)];
		
		float rise = cxn.src.concept.centerPoint.y - cxn.dst.concept.centerPoint.y;
		float run  = cxn.src.concept.centerPoint.x - cxn.dst.concept.centerPoint.x;
		
		float m = rise / run;
		CGFloat rotationRadians = atan(m);
		CGFloat angle_A = atan(m);
		CGFloat side_a = [cxn.src.concept.height floatValue] / 2;
		CGFloat side_b = side_a / tan(angle_A);
		//CGFloat side_c = sqrt(side_a * side_a + side_b * side_b);
		
		
		CGFloat side_a_to_corner = [cxn.src.concept.height floatValue] / 2;
		CGFloat side_b_to_corner = [cxn.src.concept.width floatValue] / 2;
		CGFloat angle_A_to_corner = atan(side_a_to_corner / side_b_to_corner);
		
		CGPoint connectionLabelPoint = cxn.src.concept.centerPoint;
		//		connectionLabelPoint.x += side_b;
		//		connectionLabelPoint.y += side_a;
		
		if (cxn.src.concept.centerPoint.x <= cxn.dst.concept.centerPoint.x && cxn.src.concept.centerPoint.y <= cxn.dst.concept.centerPoint.y) {
			// src is above and left of dst
			if (fabs(angle_A) > angle_A_to_corner) {
				FUNCTION_LOG(@"Exiting top a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				connectionLabelPoint.x += side_b;
				connectionLabelPoint.y += side_a;
			} else {
				FUNCTION_LOG(@"Exiting side a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				CGFloat b = [cxn.src.concept.width floatValue] / 2;
				CGFloat A = angle_A;
				CGFloat a = b * tan(A);
				
				connectionLabelPoint.y += a;
				connectionLabelPoint.x += b;
			}
		} else if (cxn.src.concept.centerPoint.x <= cxn.dst.concept.centerPoint.x && cxn.src.concept.centerPoint.y > cxn.dst.concept.centerPoint.y) {
			// src is below and left of dst
			if (fabs(angle_A) > angle_A_to_corner) {
				FUNCTION_LOG(@"Exiting top a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				connectionLabelPoint.x -= side_b;
				connectionLabelPoint.y -= side_a;
			} else {
				FUNCTION_LOG(@"Exiting side a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				CGFloat b = [cxn.src.concept.width floatValue] / 2;
				CGFloat A = angle_A;
				CGFloat a = b * tan(A);
				
				connectionLabelPoint.y += a;
				connectionLabelPoint.x += b;
			}
			
		} else if (cxn.src.concept.centerPoint.x > cxn.dst.concept.centerPoint.x && cxn.src.concept.centerPoint.y > cxn.dst.concept.centerPoint.y) {
			// src is below and right of dst
			if (fabs(angle_A) > angle_A_to_corner) {
				FUNCTION_LOG(@"Exiting top a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				rise = fabs(cxn.src.concept.centerPoint.y) - fabs(cxn.dst.concept.centerPoint.y);
				run  = fabs(cxn.src.concept.centerPoint.x) - fabs(cxn.dst.concept.centerPoint.x);
				
				m = rise / run;
				rotationRadians = atan(m);
				angle_A         = radiansToDegrees(atan(m));
				
				CGFloat a1 = [cxn.src.concept.height floatValue] / 2;
				//CGFloat B1 = (90 - angle_A);
				CGFloat c1 = a1 / sin(degreesToRadians(angle_A));
				//CGFloat b1 = sin(B1) * c1;
				
				CGFloat c2 = size.width + c1;
				CGFloat A2 = angle_A;
				CGFloat B2 = (90 - A2);
				CGFloat b2 = sin(degreesToRadians(B2)) * c2;
				CGFloat a2 = sin(degreesToRadians(A2)) * c2;
				
				connectionLabelPoint.x -= fabs(b2);
				connectionLabelPoint.y -= fabs(a2);
				
				FUNCTION_LOG(@"adj x = %.2f, y = %.2f", a2, b2);
				//				FUNCTION_LOG(@"(%.2f, %.2f) (%.2f, %.2f) %.2f", b1, a1, b2, a2, size.width);
			} else {
				FUNCTION_LOG(@"Exiting side a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				rise = fabs(cxn.src.concept.centerPoint.y) - fabs(cxn.dst.concept.centerPoint.y);
				run  = fabs(cxn.src.concept.centerPoint.x) - fabs(cxn.dst.concept.centerPoint.x);
				
				m = rise / run;
				rotationRadians = atan(m);
				angle_A         = radiansToDegrees(atan(m));
				
				CGFloat b1 = [cxn.src.concept.width floatValue] / 2;
				CGFloat B1 = (90 - angle_A);
				CGFloat c1 = b1 / sin(degreesToRadians(B1));
				//CGFloat b1 = sin(B1) * c1;
				
				CGFloat c2 = size.width + c1;
				CGFloat A2 = angle_A;
				CGFloat B2 = (90 - A2);
				CGFloat b2 = sin(degreesToRadians(B2)) * c2;
				CGFloat a2 = sin(degreesToRadians(A2)) * c2;
				
				connectionLabelPoint.x -= fabs(b2);
				connectionLabelPoint.y -= fabs(a2);
				
				FUNCTION_LOG(@"adj x = %.2f, y = %.2f", a2, b2);
			}
			
		} else if (cxn.src.concept.centerPoint.x > cxn.dst.concept.centerPoint.x && cxn.src.concept.centerPoint.y <= cxn.dst.concept.centerPoint.y) {
			// src is above and right of dst
			if (fabs(angle_A) > angle_A_to_corner) {
				FUNCTION_LOG(@"Exiting bottom a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				rise = fabs(cxn.src.concept.centerPoint.y) - fabs(cxn.dst.concept.centerPoint.y);
				run  = fabs(cxn.src.concept.centerPoint.x) - fabs(cxn.dst.concept.centerPoint.x);
				
				m = rise / run;
				rotationRadians = atan(m);
				angle_A         = radiansToDegrees(atan(m));
				
				CGFloat a1 = [cxn.src.concept.height floatValue] / 2;
				CGFloat c1 = fabs(a1 / sin(degreesToRadians(angle_A)));
				//CGFloat b1 = sin(B1) * c1;
				
				CGFloat c2 = size.width + c1;
				CGFloat A2 = angle_A;
				CGFloat B2 = (90 - A2);
				CGFloat b2 = sin(degreesToRadians(B2)) * c2;
				CGFloat a2 = sin(degreesToRadians(A2)) * c2;
				
				connectionLabelPoint.x -= fabs(b2);
				connectionLabelPoint.y += fabs(a2);
				
				FUNCTION_LOG(@"adj x = %.2f, y = %.2f", a2, b2);
				//				FUNCTION_LOG(@"(%.2f, %.2f) (%.2f, %.2f) %.2f", b1, a1, b2, a2, size.width);
			} else {
				FUNCTION_LOG(@"Exiting side a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				rise = fabs(cxn.src.concept.centerPoint.y) - fabs(cxn.dst.concept.centerPoint.y);
				run  = fabs(cxn.src.concept.centerPoint.x) - fabs(cxn.dst.concept.centerPoint.x);
				
				m = rise / run;
				rotationRadians = atan(m);
				angle_A         = fabs(radiansToDegrees(atan(m)));
				
				CGFloat b1 = [cxn.src.concept.width floatValue] / 2;
				CGFloat B1 = (90 - angle_A);
				CGFloat c1 = b1 / sin(degreesToRadians(B1));
				//CGFloat b1 = sin(B1) * c1;
				
				CGFloat c2 = size.width + c1;
				CGFloat A2 = angle_A;
				CGFloat B2 = (90 - A2);
				CGFloat b2 = sin(degreesToRadians(B2)) * c2;
				CGFloat a2 = sin(degreesToRadians(A2)) * c2;
				
				connectionLabelPoint.x -= fabs(b2);
				connectionLabelPoint.y += fabs(a2);
				
				FUNCTION_LOG(@"adj x = %.2f, y = %.2f", a2, b2);
			}
		}
		
		FUNCTION_LOG(@"origin=(%.2f, %.2f) Slope = %.2f, angle = %.2f", cxn.src.concept.centerPoint.x, cxn.src.concept.centerPoint.y, m, rotationRadians);
		
		/*
		 We might only know one side but we also know an angle. For example, if the side a = 15 and the angle A = 41°, 
		 we can use a sine and a tangent to find the hypotenuse and the other side. 
		 Since sin A = a/c, we know c = a/sin A = 15/sin 41. Using a calculator, 
		 this is 15/0.6561 = 22.864. Also, tan A = a/b, so b = a/tan A = 15/tan 41 = 15/0.8693 = 17.256. 
		 Whether you use a sine, cosine, or tangent depends on which side and angle you know.
		 */
		//		CGAffineTransform transform;
		//		CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
		//		transform =  CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), rotationRadians * -1);
		//		CGContextSetTextMatrix(context, transform);
		//		CGContextShowTextAtPoint(context, connectionLabelPoint.x, connectionLabelPoint.y, [title UTF8String], strlen([title UTF8String]));
		
		//		CGContextSaveGState(context);
		//		cxn.layer.anchorPoint = CGPointMake(0, 0);

//		CGRect currentFrame = cxn.connectionTitleView.frame;
//		currentFrame.origin.x = connectionLabelPoint.x;
//		currentFrame.origin.y = connectionLabelPoint.y;
//		[cxn.connectionTitleView setFrame:currentFrame];
		cxn.layer.position = connectionLabelPoint;
		

		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
		
//		[cxn.connectionTitleView setFrame:CGRectMake(connectionLabelPoint.x, connectionLabelPoint.y, size.width, size.height)];
		FUNCTION_LOG(@"%@ height=%.2f", cxn.connectionDescription, size.height);

//		[cxn.layer setValue:[NSNumber numberWithFloat:rotationRadians] forKey:@"rotation.x"];
//		[cxn.layer setValue:[NSNumber numberWithFloat:rotationRadians] forKey:@"rotation.y"];
//		[cxn.layer setValue:[NSNumber numberWithFloat:rotationRadians] forKeyPath:@"transform.rotation.z"];
		
		
		//		CGAffineTransform transformStraight	= CGAffineTransformMakeRotation(0);
		//		[cxn.layer setAffineTransform:transformStraight];
		
		cxn.layer.anchorPoint = CGPointMake(0, 0);
//		CGAffineTransform transformScale	= CGAffineTransformMakeScale(1.f, 1.f);
//		CGAffineTransform transformRotate	= CGAffineTransformMakeRotation(rotationRadians);
		
		//[cxn.layer setAffineTransform:CGAffineTransformIdentity];
//		[cxn.layer setAffineTransform:CGAffineTransformMakeRotation(0)];
//		CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationRadians);
//		transform	= CGAffineTransformScale(transform, 1.f, 1.f);

		[cxn.layer setAffineTransform:CGAffineTransformMakeRotation(rotationRadians)];
		
//		[CATransaction setValue:[NSNumber numberWithFloat:3.0f]
//						 forKey:kCATransactionAnimationDuration];
//		cxn.layer.transform = CATransform3DMakeRotation(rotationRadians, 0.0, 0.0, 1.0);

//		CAKeyframeAnimation *rotation = [CAKeyframeAnimation animation];
//			rotation.values = [NSArray arrayWithObjects:
////							   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f)],
//							   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(rotationRadians, 1.0f, 0.0f, 0.0f)],
//nil];
//		rotation.duration = 1.f;
//		rotation.delegate = self;
//		rotation.autoreverses = NO;
//		
//		[[self layer] addAnimation:rotation forKey:@"transform"];
		
		[CATransaction commit];
	}
	
}

//- (void)layoutSubviews {
//	FUNCTION_LOG();
////	[self drawInContext:UIGraphicsGetCurrentContext()];
//	[self resetTheConnectionLabels];
//}

- (void)drawInContext:(CGContextRef)context {
	//FUNCTION_LOG();
	UIGraphicsPushContext(context);

	CGContextSetLineWidth(context, 3.0);
	CGPoint srcPoint, dstPoint;
	for (NSString *key in connections) {
		ConceptObjectConnection *cxn = (ConceptObjectConnection *)[connections valueForKey:key];

		srcPoint = cxn.src.concept.centerPoint;
		CGContextMoveToPoint(context, srcPoint.x, srcPoint.y);
		
		dstPoint = cxn.dst.concept.centerPoint;
		CGContextAddLineToPoint(context, dstPoint.x, dstPoint.y);

		CGContextStrokePath(context);
		//FUNCTION_LOG(@"Draw from (%.2f, %.2f) to (%.2f, %.2f)", srcPoint.x, srcPoint.y, dstPoint.x, dstPoint.y);
		// ========================================================
		NSString *title = [[NSString alloc] initWithFormat:@" %@ ", cxn.connectionDescription];
//		NSString *title = @"x";
		FUNCTION_LOG(@"Title = (%@)", title);
		UIFont *font = [UIFont systemFontOfSize:12];
		CGSize size = [title sizeWithFont:font];
		
		cxn.layer.string = title;
		
		[cxn.layer setBounds:CGRectMake(0, 0, size.width, size.height)];
		
		//	CGPoint pointStartOfText = CGPointMake(textX, textY);
		CGContextSetTextPosition(context, 0, 0);
		CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor); // foreground

		float rise = cxn.src.concept.centerPoint.y - cxn.dst.concept.centerPoint.y;
		float run  = cxn.src.concept.centerPoint.x - cxn.dst.concept.centerPoint.x;
		
		float m = rise / run;
		CGFloat rotationRadians = atan(m);
		CGFloat angle_A = atan(m);
		CGFloat side_a = [cxn.src.concept.height floatValue] / 2;
		CGFloat side_b = side_a / tan(angle_A);
		//CGFloat side_c = sqrt(side_a * side_a + side_b * side_b);
		
		
		CGFloat side_a_to_corner = [cxn.src.concept.height floatValue] / 2;
		CGFloat side_b_to_corner = [cxn.src.concept.width floatValue] / 2;
		CGFloat angle_A_to_corner = atan(side_a_to_corner / side_b_to_corner);

		CGPoint connectionLabelPoint = cxn.src.concept.centerPoint;
//		connectionLabelPoint.x += side_b;
//		connectionLabelPoint.y += side_a;

		if (cxn.src.concept.centerPoint.x <= cxn.dst.concept.centerPoint.x && cxn.src.concept.centerPoint.y <= cxn.dst.concept.centerPoint.y) {
			// src is above and left of dst
			if (fabs(angle_A) > angle_A_to_corner) {
				FUNCTION_LOG(@"Exiting top a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				connectionLabelPoint.x += side_b;
				connectionLabelPoint.y += side_a;
			} else {
				FUNCTION_LOG(@"Exiting side a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				CGFloat b = [cxn.src.concept.width floatValue] / 2;
				CGFloat A = angle_A;
				CGFloat a = b * tan(A);
				
				connectionLabelPoint.y += a;
				connectionLabelPoint.x += b;
			}
		} else if (cxn.src.concept.centerPoint.x <= cxn.dst.concept.centerPoint.x && cxn.src.concept.centerPoint.y > cxn.dst.concept.centerPoint.y) {
			// src is below and left of dst
			if (fabs(angle_A) > angle_A_to_corner) {
				FUNCTION_LOG(@"Exiting top a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				connectionLabelPoint.x -= side_b;
				connectionLabelPoint.y -= side_a;
			} else {
				FUNCTION_LOG(@"Exiting side a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				CGFloat b = [cxn.src.concept.width floatValue] / 2;
				CGFloat A = angle_A;
				CGFloat a = b * tan(A);
				
				connectionLabelPoint.y += a;
				connectionLabelPoint.x += b;
			}

		} else if (cxn.src.concept.centerPoint.x > cxn.dst.concept.centerPoint.x && cxn.src.concept.centerPoint.y > cxn.dst.concept.centerPoint.y) {
			// src is below and right of dst
			if (fabs(angle_A) > angle_A_to_corner) {
				FUNCTION_LOG(@"Exiting top a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);

				rise = fabs(cxn.src.concept.centerPoint.y) - fabs(cxn.dst.concept.centerPoint.y);
				run  = fabs(cxn.src.concept.centerPoint.x) - fabs(cxn.dst.concept.centerPoint.x);
				
				m = rise / run;
				rotationRadians = atan(m);
				angle_A         = radiansToDegrees(atan(m));
				
				CGFloat a1 = [cxn.src.concept.height floatValue] / 2;
				//CGFloat B1 = (90 - angle_A);
				CGFloat c1 = a1 / sin(degreesToRadians(angle_A));
				//CGFloat b1 = sin(B1) * c1;
				
				CGFloat c2 = size.width + c1;
				CGFloat A2 = angle_A;
				CGFloat B2 = (90 - A2);
				CGFloat b2 = sin(degreesToRadians(B2)) * c2;
				CGFloat a2 = sin(degreesToRadians(A2)) * c2;
				
				connectionLabelPoint.x -= fabs(b2);
				connectionLabelPoint.y -= fabs(a2);
				
				FUNCTION_LOG(@"adj x = %.2f, y = %.2f", a2, b2);
//				FUNCTION_LOG(@"(%.2f, %.2f) (%.2f, %.2f) %.2f", b1, a1, b2, a2, size.width);
			} else {
				FUNCTION_LOG(@"Exiting side a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				rise = fabs(cxn.src.concept.centerPoint.y) - fabs(cxn.dst.concept.centerPoint.y);
				run  = fabs(cxn.src.concept.centerPoint.x) - fabs(cxn.dst.concept.centerPoint.x);
				
				m = rise / run;
				rotationRadians = atan(m);
				angle_A         = radiansToDegrees(atan(m));
				
				CGFloat b1 = [cxn.src.concept.width floatValue] / 2;
				CGFloat B1 = (90 - angle_A);
				CGFloat c1 = b1 / sin(degreesToRadians(B1));
				//CGFloat b1 = sin(B1) * c1;
				
				CGFloat c2 = size.width + c1;
				CGFloat A2 = angle_A;
				CGFloat B2 = (90 - A2);
				CGFloat b2 = sin(degreesToRadians(B2)) * c2;
				CGFloat a2 = sin(degreesToRadians(A2)) * c2;
				
				connectionLabelPoint.x -= fabs(b2);
				connectionLabelPoint.y -= fabs(a2);
				
				FUNCTION_LOG(@"adj x = %.2f, y = %.2f", a2, b2);
			}
			
		} else if (cxn.src.concept.centerPoint.x > cxn.dst.concept.centerPoint.x && cxn.src.concept.centerPoint.y <= cxn.dst.concept.centerPoint.y) {
			// src is above and right of dst
			if (fabs(angle_A) > angle_A_to_corner) {
				FUNCTION_LOG(@"Exiting bottom a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				rise = fabs(cxn.src.concept.centerPoint.y) - fabs(cxn.dst.concept.centerPoint.y);
				run  = fabs(cxn.src.concept.centerPoint.x) - fabs(cxn.dst.concept.centerPoint.x);
				
				m = rise / run;
				rotationRadians = atan(m);
				angle_A         = radiansToDegrees(atan(m));
				
				CGFloat a1 = [cxn.src.concept.height floatValue] / 2;
				CGFloat c1 = fabs(a1 / sin(degreesToRadians(angle_A)));
				//CGFloat b1 = sin(B1) * c1;
				
				CGFloat c2 = size.width + c1;
				CGFloat A2 = angle_A;
				CGFloat B2 = (90 - A2);
				CGFloat b2 = sin(degreesToRadians(B2)) * c2;
				CGFloat a2 = sin(degreesToRadians(A2)) * c2;
				
				connectionLabelPoint.x -= fabs(b2);
				connectionLabelPoint.y += fabs(a2);
				
				FUNCTION_LOG(@"adj x = %.2f, y = %.2f", a2, b2);
				//				FUNCTION_LOG(@"(%.2f, %.2f) (%.2f, %.2f) %.2f", b1, a1, b2, a2, size.width);
			} else {
				FUNCTION_LOG(@"Exiting side a=%.2f, ac=%.2f", fabs(angle_A), angle_A_to_corner);
				
				rise = fabs(cxn.src.concept.centerPoint.y) - fabs(cxn.dst.concept.centerPoint.y);
				run  = fabs(cxn.src.concept.centerPoint.x) - fabs(cxn.dst.concept.centerPoint.x);
				
				m = rise / run;
				rotationRadians = atan(m);
				angle_A         = fabs(radiansToDegrees(atan(m)));
				
				CGFloat b1 = [cxn.src.concept.width floatValue] / 2;
				CGFloat B1 = (90 - angle_A);
				CGFloat c1 = b1 / sin(degreesToRadians(B1));
				//CGFloat b1 = sin(B1) * c1;
				
				CGFloat c2 = size.width + c1;
				CGFloat A2 = angle_A;
				CGFloat B2 = (90 - A2);
				CGFloat b2 = sin(degreesToRadians(B2)) * c2;
				CGFloat a2 = sin(degreesToRadians(A2)) * c2;
				
				connectionLabelPoint.x -= fabs(b2);
				connectionLabelPoint.y += fabs(a2);
				
				FUNCTION_LOG(@"adj x = %.2f, y = %.2f", a2, b2);
			}
		}

		FUNCTION_LOG(@"origin=(%.2f, %.2f) Slope = %.2f, angle = %.2f", cxn.src.concept.centerPoint.x, cxn.src.concept.centerPoint.y, m, rotationRadians);

		/*
		 We might only know one side but we also know an angle. For example, if the side a = 15 and the angle A = 41°, 
		 we can use a sine and a tangent to find the hypotenuse and the other side. 
		 Since sin A = a/c, we know c = a/sin A = 15/sin 41. Using a calculator, 
		 this is 15/0.6561 = 22.864. Also, tan A = a/b, so b = a/tan A = 15/tan 41 = 15/0.8693 = 17.256. 
		 Whether you use a sine, cosine, or tangent depends on which side and angle you know.
		 */

		cxn.layer.position = connectionLabelPoint;
		cxn.layer.anchorPoint = CGPointMake(0, 0);
		[cxn.layer setAffineTransform:CGAffineTransformMakeRotation(rotationRadians)];
		
		// ========================================================
	}
	UIGraphicsPopContext();
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	//FUNCTION_LOG();
	[self drawInContext:ctx];
}


- (void)addConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst with:(ConnectedConcept *)connectedConcept{
	ConceptObjectConnection *cxn = [[ConceptObjectConnection alloc] init];
	[cxn initSource:src dest:dst label:connectedConcept];
	[self.layer addSublayer:cxn.layer];
	
	[connections setObject:cxn forKey:cxn.keyString];
	FUNCTION_LOG(@"Key %@ (%i), %i connections now exist", cxn.keyString, cxn.keyString, [connections count]);
	[self.layer setNeedsDisplay];
//	[cxn release];
}

- (void)removeConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst {
	ConceptObjectConnection *cxn = [[ConceptObjectConnection alloc] init];
	cxn.src = src;
	cxn.dst = dst;
	//ConceptObjectConnection *cxn2delete = [connections objectForKey:cxn.keyString];
	[connections removeObjectForKey:cxn.keyString];
	
	FUNCTION_LOG(@"Key %@ (%i), %i connections remain", cxn.keyString, cxn.keyString, [connections count]);
	FUNCTION_LOG(@"From %@ to %@", src.concept.title, dst.concept.title);
	[self setNeedsDisplay];
	[cxn release];
}

- (void)removeConnectionsToAndFrom:(ConceptObject *)conceptObject {
	for (ConceptObjectConnection *connection in [connections allValues]) {
		if (connection.src == conceptObject || connection.dst == conceptObject) {
			[connections removeObjectForKey:connection.keyString];
		}
	}
	[self setNeedsDisplay];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController {
	FUNCTION_LOG();
	[self.layer setNeedsDisplay];
}
@end
