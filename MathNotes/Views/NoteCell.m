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
    
    self.lastUpdatedTimeLabel.text = [@"Modified: " stringByAppendingString:[self.note.updatedAt timeAgoSinceNow]];
    if ([self.note.author.username isEqualToString:[PFUser currentUser].username]){
        self.ownedByLabel.text =   @"Owned by: Me";
    }
    else{
         self.ownedByLabel.text =[@"Owned by: " stringByAppendingString:self.note.author.username];
    }
}
- (IBAction)renameNote:(id)sender {
    [self.delegate didTapRename:self.note];
    [self updateCell];
}
- (IBAction)shareNote:(id)sender {
    [self.delegate didTapShare:self.note];
    [self updateCell];
}



@end
