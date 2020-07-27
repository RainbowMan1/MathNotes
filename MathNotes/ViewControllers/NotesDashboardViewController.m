//
//  NotesDashboardViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "NotesDashboardViewController.h"
#import "Parse/Parse.h"
#import "NoteCell.h"
#import "SceneDelegate.h"
#import "NotesEditorViewController.h"

@interface NotesDashboardViewController ()<UITableViewDataSource, UITableViewDelegate, NoteCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *notes;
@property (strong, nonatomic) NSMutableArray *currentNotes;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end

@implementation NotesDashboardViewController


#pragma mark - View Config
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self fetchNotes];
    
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNotes) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    [self fetchNotes];
}

#pragma mark - fetch from database

- (void)fetchNotes {
    PFQuery *query = [PFQuery queryWithClassName:@"Notes"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
        // fetch data asynchronously
        [query findObjectsInBackgroundWithBlock:^(NSArray *notesArray, NSError *error) {
            if (notesArray != nil) {
                self.notes = [notesArray mutableCopy];
                self.currentNotes = [notesArray mutableCopy];
                [self textFieldDidChange:self.searchField];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            } else {
            }
        }];
}

#pragma mark - Search bar

-(void)textFieldDidChange :(UITextField *) textField{
    [self.currentNotes removeAllObjects];
    if ([self.searchField.text isEqualToString:@""]) {
        self.currentNotes = [[NSMutableArray alloc]initWithArray:self.notes];
    }
    for (Note *note in self.notes){
        if ([[note.noteName lowercaseString] rangeOfString:[self.searchField.text lowercaseString]].location != NSNotFound) {
            [self.currentNotes addObject:note];
        }
    }
    [self.tableView reloadData];
}
- (void)hideKeyboard {
    [self.searchField endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentNotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.note = self.currentNotes[indexPath.row];
    
    return cell;
}
#pragma mark - Table view delete

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you Sure?"
                                                                           message:@"Do you want to delete the note"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                [self.tableView beginUpdates];
                [self.notes removeObject:self.currentNotes[indexPath.row]];
                [self.currentNotes[indexPath.row] deleteInBackground];
                [self.currentNotes removeObjectAtIndex:indexPath.row];
                
                [self.tableView deleteRowsAtIndexPaths:[NSArray<NSIndexPath *> arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No"
          style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        [yesAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
            
            [alert addAction:cancelAction];
        [alert addAction:yesAction];
            [self presentViewController:alert animated:YES completion:^{}];
        
    }
}

#pragma mark - NoteCell Delegate
- (void) didTapRename:(Note *)note{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: [@"Rename " stringByAppendingString:note.noteName]
                                                                                  message: @"Type new name for the note"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = note.noteName;
        textField.clearsOnInsertion =YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSLog(@"%@",namefield.text);
        note.noteName = namefield.text;
        [Note updateNote:note withCompletion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewNote"]) {
        NotesEditorViewController *noteEditor = [segue destinationViewController];
        Note *newNote = [Note new];
        newNote.noteName = @"Untitled Note";
        noteEditor.note = newNote;
    }
    else if ([segue.identifier isEqualToString:@"EditNote"]) {
        NotesEditorViewController *noteEditor = [segue destinationViewController];
        NoteCell *selectedcell = (NoteCell*) sender;
        //NSLog(@"%@",selectedcell.note.htmlText);
        noteEditor.note = selectedcell.note;
    }
}

@end
