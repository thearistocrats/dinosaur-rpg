# dinosaur-rpg
A video game for the GDDC

# Folder Guide
Game Objects are compleated scenes and their scripts, they should be able to be instanciated out of the box
assets are the assets used
scenes are wip scenes
scripts are scripts used in multiple places

currently the workflow looks as such:
  The dinosaur script is used to store information about the dinosaur itself, including actions, health, stamina, armor, and the dinosaurs identity\n
  The dinosaur script is used in a dinosaur scene to make the dinosaur itself\n
  the dinosaurs are then used in the combat handler to set up an example encounter\n
currently only one dinosaur is created, the base dinosaur
