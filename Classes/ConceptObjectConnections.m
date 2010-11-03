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


- (id)init {
	FUNCTION_LOG();
	[super init];
	
	connections = [[NSMutableDictionary alloc] init];
	return self;
}

- (void)drawInContext:(CGContextRef)context {
	FUNCTION_LOG();

	CGContextSetLineWidth(context, 3.0);
	CGPoint srcPoint, dstPoint;
	for (NSString *key in connections) {
		ConceptObjectConnection *cxn = (ConceptObjectConnection *)[connections valueForKey:key];

		srcPoint = cxn.src.concept.centerPoint;
		//FUNCTION_LOG(@"Src (%.2f, %.2f) %@", srcPoint.x, srcPoint.y, cxn.src.concept.title);
		CGContextMoveToPoint(context, srcPoint.x, srcPoint.y);
		
		dstPoint = cxn.dst.concept.centerPoint;
		//FUNCTION_LOG(@"Dst 1 (%.2f, %.2f) %@", dstPoint.x, dstPoint.y, cxn.dst.concept.title);

		CGContextAddLineToPoint(context, dstPoint.x, dstPoint.y);

		CGContextStrokePath(context);
		//FUNCTION_LOG(@"Draw from (%.2f, %.2f) to (%.2f, %.2f)", srcPoint.x, srcPoint.y, dstPoint.x, dstPoint.y);
		// ========================================================
		UIGraphicsPushContext(context);
		NSString *title = [[NSString alloc] initWithFormat:@"%@  ", cxn.dst.concept.title];
//		NSString *title = @"x";
		UIFont *font = [UIFont systemFontOfSize:12];
		CGSize size = [title sizeWithFont:font];
		
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
		CGFloat side_c = sqrt(side_a * side_a + side_b * side_b);
		
		
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

//		if (abs(connectionLabelPoint.x - cxn.src.concept.centerPoint.x) > [cxn.src.concept.width floatValue]) {
//			connectionLabelPoint.x = [cxn.src.concept.width floatValue];
//		}
//		if (abs(connectionLabelPoint.y - cxn.src.concept.centerPoint.y) > [cxn.src.concept.height floatValue]) {
//			connectionLabelPoint.y = [cxn.src.concept.height floatValue];
//		}
//		
		
		FUNCTION_LOG(@"origin=(%.2f, %.2f) Slope = %.2f, angle = %.2f, c=%.2f", cxn.src.concept.centerPoint.x, cxn.src.concept.centerPoint.y, m, rotationRadians, side_c);

		/*
		 We might only know one side but we also know an angle. For example, if the side a = 15 and the angle A = 41°, 
		 we can use a sine and a tangent to find the hypotenuse and the other side. 
		 Since sin A = a/c, we know c = a/sin A = 15/sin 41. Using a calculator, 
		 this is 15/0.6561 = 22.864. Also, tan A = a/b, so b = a/tan A = 15/tan 41 = 15/0.8693 = 17.256. 
		 Whether you use a sine, cosine, or tangent depends on which side and angle you know.
		 */
		CGAffineTransform transform;
		CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
		transform =  CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), rotationRadians * -1);
		CGContextSetTextMatrix(context, transform);
		CGContextShowTextAtPoint(context, connectionLabelPoint.x, connectionLabelPoint.y, [title UTF8String], strlen([title UTF8String]));
//		[title drawAtPoint:connectionLabelPoint withFont:font];
		
//		CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
//		CGContextSetTextMatrix(context, transform);
//		CGContextSetTextDrawingMode(context, kCGTextFill);
////		CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
//		CGContextShowTextAtPoint(context, 100.0, 100.0, "test", strlen("test"));

//		CGAffineTransform transform;
//		transform =  CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ),(-45.0f * M_PI / 180));
//		CGContextSelectFont(context, "Helvetica", 36.0, kCGEncodingMacRoman);
//		// Next we set the text matrix to flip our text upside down. We do this because the context itself
//		// is flipped upside down relative to the expected orientation for drawing text (much like the case for drawing Images & PDF).
//		CGContextSetTextMatrix(context, transform);
//		// And now we actually draw some text. This screen will demonstrate the typical drawing modes used.
//		CGContextSetTextDrawingMode(context, kCGTextFill);
//		CGContextShowTextAtPoint(context, 50.0, 50.0, "test", strlen("test"));
//
//		CGContextSetTextMatrix(context, CGAffineTransformMakeRotation(45.0f));
//		// And now we actually draw some text. This screen will demonstrate the typical drawing modes used.
//		CGContextSetTextDrawingMode(context, kCGTextFill);
//		CGContextShowTextAtPoint(context, 50.0, 100.0, "test2", strlen("test2"));
		
		UIGraphicsPopContext();
		// ========================================================
	}
}

- (void)addConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst {
	ConceptObjectConnection *cxn = [[ConceptObjectConnection alloc] init];
	cxn.src = src;
	cxn.dst = dst;
	[connections setObject:cxn forKey:cxn.keyString];
	FUNCTION_LOG(@"Key %@ (%i), %i connections now exist", cxn.keyString, cxn.keyString, [connections count]);
	[self setNeedsDisplay];
//	[cxn release];
}

- (void)removeConnectionFrom:(ConceptObject *)src to:(ConceptObject *)dst {
	ConceptObjectConnection *cxn = [[ConceptObjectConnection alloc] init];
	cxn.src = src;
	cxn.dst = dst;
	ConceptObjectConnection *cxn2delete = [connections objectForKey:cxn.keyString];
	[connections removeObjectForKey:cxn.keyString];
	
	FUNCTION_LOG(@"Key %@ (%i), %i connections remain (%i)", cxn.keyString, cxn.keyString, [connections count], cxn2delete);
	FUNCTION_LOG(@"From %@ to %@", src.concept.title, dst.concept.title);
	[self setNeedsDisplay];
//	[cxn release];
}

- (void)removeConnectionsToAndFrom:(ConceptObject *)conceptObject {
	for (ConceptObjectConnection *connection in [connections allValues]) {
		if (connection.src == conceptObject || connection.dst == conceptObject) {
			[connections removeObjectForKey:connection.keyString];
		}
	}
	[self setNeedsDisplay];
}

@end
