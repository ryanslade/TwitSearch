//
//  TwitTableViewCell.m
//  TwitSearch
//
//  Created by slader on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TwitTableViewCell.h"


@implementation TwitTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.font = [TwitTableViewCell detailFont];
        self.textLabel.font = [TwitTableViewCell textFont];
        
        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.detailTextLabel.numberOfLines = NSIntegerMax;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

+ (UIFont*) detailFont
{
    return [UIFont fontWithName:@"Helvetica" size:14];
}

+ (UIFont*) textFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
