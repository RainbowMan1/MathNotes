//
//  EquationSnipCell.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationSnipCell.h"
#import "NSDate+DateTools.h"

@implementation EquationSnipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setEquationSnip:(EquationSnip *)equationSnip {
    (_equationSnip) = equationSnip;
    [self updateCell];
}

- (void)updateCell {
    self.equationSnipName.text =  self.equationSnip.equationSnipName;
    self.lastUpdatedTimeLabel.text = [self.equationSnip.updatedAt timeAgoSinceNow];
    if ([self.equationSnip.author.username isEqualToString:[PFUser currentUser].username]){
        [self.ownedImage setHidden:YES];
        [self.renameView setHidden:NO];
        [self.ownerName setHidden:YES];
        [self.ownerColorView setBackgroundColor:[UIColor systemOrangeColor]];
    }
    else{
        self.ownerName.text = [@"Shared By: " stringByAppendingString:self.equationSnip.author.username];
        [self.ownedImage setHidden:NO];
        [self.renameView setHidden:YES];
        [self.ownerColorView setBackgroundColor:[UIColor systemBlueColor]];
    }
}
- (IBAction)renameEquationSnip:(id)sender {
    [self.delegate didTapRename:self.equationSnip withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [self updateCell];
        }
    }];
}
- (IBAction)shareEquationSnip:(id)sender {
    [self.delegate didTapShare:self.equationSnip withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [self updateCell];
        }
    }];
}

@end
