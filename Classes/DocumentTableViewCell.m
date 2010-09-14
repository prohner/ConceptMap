//
//  DocumentTableViewCell.m
//  ConceptMap
//
//  Created by Preston Rohner on 9/13/10.
//  Copyright 2010 Cool Tool Apps. All rights reserved.
//

#import "DocumentTableViewCell.h"


@implementation DocumentTableViewCell

@synthesize title, imageView, created, saved;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
