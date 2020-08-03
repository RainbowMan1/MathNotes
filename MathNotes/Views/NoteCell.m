//
//  NoteCell.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "NoteCell.h"
#import "Note.h"
#import "NSDate+DateTools.h"
#import "Parse/Parse.h"

@implementation NoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNote:(Note *)note {
    _note = note;
    [self updateCell];
}

- (void)updateCell {
    self.noteNameLabel.text =  self.note.noteName;
    
    self.lastUpdatedTimeLabel.text = [self.note.updatedAt timeAgoSinceNow];
    if ([self.note.author.username isEqualToString:[PFUser currentUser].username]){
        self.ownedByLabel.text =   @"Owned by: Me";
        [self.ownerColorView setBackgroundColor:[UIColor systemBlueColor]];
    }
    else{
         self.ownedByLabel.text = self.note.author.username;
        [self.ownerColorView setBackgroundColor:[UIColor systemOrangeColor]];
    }
}
- (IBAction)renameNote:(id)sender {
    [self.delegate didTapRename:self.note withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [self updateCell];
        }
    }];
    
}
- (IBAction)shareNote:(id)sender {
    [self.delegate didTapShare:self.note withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            [self updateCell];
        }
    }];
    
}



@end
