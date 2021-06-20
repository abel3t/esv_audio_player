import 'package:esv_audio_player/CustomWidgets/GradientContainers.dart';
import 'package:esv_audio_player/CustomWidgets/collage.dart';
import 'package:esv_audio_player/Helpers/import_export_playlist.dart';
import 'package:esv_audio_player/Screens/Library/liked.dart';
import 'package:esv_audio_player/CustomWidgets/miniplayer.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Box settingsBox = Hive.box('settings');
  List playlistNames = [];
  Map playlistDetails = {};
  @override
  Widget build(BuildContext context) {
    playlistNames = settingsBox.get('playlistNames')?.toList() ?? [];
    playlistDetails = settingsBox.get('playlistDetails', defaultValue: {});

    return GradientContainer(
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  'Playlists',
                ),
                centerTitle: true,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Theme.of(context).accentColor,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 5),
                    ListTile(
                      title: Text('Create Playlist'),
                      leading: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Icon(
                              Icons.add_rounded,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? null
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final _controller = TextEditingController();
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Create new playlist',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                      controller: _controller,
                                      autofocus: true,
                                      onSubmitted: (String value) {
                                        if (value.trim() == '')
                                          value =
                                              'Playlist ${playlistNames.length}';
                                        if (playlistNames.contains(value))
                                          value = value + ' (1)';
                                        playlistNames.add(value);
                                        settingsBox.put(
                                            'playlistNames', playlistNames);
                                        Navigator.pop(context);
                                        setState(() {});
                                      }),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.grey[700],
                                    //       backgroundColor: Theme.of(context).accentColor,
                                  ),
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                  ),
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (_controller.text.trim() == '')
                                      _controller.text =
                                          'Playlist ${playlistNames.length}';

                                    if (playlistNames
                                        .contains(_controller.text))
                                      _controller.text =
                                          _controller.text + ' (1)';
                                    playlistNames.add(_controller.text);
                                    settingsBox.put(
                                        'playlistNames', playlistNames);
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                        title: Text('Import from File'),
                        leading: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: Icon(
                                MdiIcons.import,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? null
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          playlistNames = await ImportPlaylist()
                              .importPlaylist(context, playlistNames);
                          settingsBox.put('playlistNames', playlistNames);
                          setState(() {});
                        }),playlistNames.isEmpty
                        ? SizedBox()
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: playlistNames.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: playlistDetails[
                                                playlistNames[index]] ==
                                            null ||
                                        playlistDetails[playlistNames[index]]
                                                ['imagesList'] ==
                                            null
                                    ? Card(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Center(
                                                child: Icon(Icons
                                                    .queue_music_rounded))),
                                      )
                                    : Collage(
                                        imageList: playlistDetails[
                                            playlistNames[index]]['imagesList'],
                                        placeholderImage: 'assets/cover.jpg'),
                                title: Text('${playlistNames[index]}'),
                                subtitle: Text(playlistDetails[
                                                playlistNames[index]] ==
                                            null ||
                                        playlistDetails[playlistNames[index]]
                                                ['count'] ==
                                            0
                                    ? ''
                                    : '${playlistDetails[playlistNames[index]]['count']} Songs'),
                                trailing: PopupMenuButton(
                                  icon: Icon(Icons.more_vert_rounded),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0))),
                                  onSelected: (value) async {
                                    if (value == 1) {
                                      ExportPlaylist().exportPlaylist(
                                          context, playlistNames[index]);
                                    }
                                    if (value == 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          elevation: 6,
                                          backgroundColor: Colors.grey[900],
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            'Deleted ${playlistNames[index]}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          action: SnackBarAction(
                                            textColor:
                                                Theme.of(context).accentColor,
                                            label: 'Ok',
                                            onPressed: () {},
                                          ),
                                        ),
                                      );
                                      playlistDetails
                                          .remove(playlistNames[index]);
                                      await settingsBox.put(
                                          'playlistDetails', playlistDetails);
                                      await Hive.openBox(playlistNames[index]);
                                      await Hive.box(playlistNames[index])
                                          .deleteFromDisk();
                                      await playlistNames.removeAt(index);
                                      await settingsBox.put(
                                          'playlistNames', playlistNames);
                                      setState(() {});
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_rounded),
                                          Spacer(),
                                          Text('Delete'),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(MdiIcons.export),
                                          Spacer(),
                                          Text('Export'),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await Hive.openBox(playlistNames[index]);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LikedSongs(
                                              playlistName:
                                                  playlistNames[index])));
                                  // Navigator.pushNamed(context, '/liked');
                                },
                              );
                            })
                  ],
                ),
              ),
            ),
          ),
          MiniPlayer(),
        ],
      ),
    );
  }
}

void addPlaylist(String name, Map info) async {
  if (name != 'Favorite Songs') await Hive.openBox(name);
  Box playlistBox = Hive.box(name);
  playlistBox.put(info['id'].toString(), info);
}