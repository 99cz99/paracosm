import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/assistant/presentation/assistants_screen.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../splash/splash_screen.dart';
import '../../features/contacts/presentation/character_detail_screen.dart';
import '../../features/contacts/presentation/character_edit_screen.dart';
import '../../features/contacts/presentation/character_import_screen.dart';
import '../../features/contacts/presentation/contacts_screen.dart';
import '../../features/group_chat/presentation/group_chat_screen.dart';
import '../../features/group_chat/presentation/group_create_screen.dart';
import '../../features/group_chat/presentation/group_info_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/profile/presentation/preset_settings_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/provider_settings_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/spec/presentation/doc_screen.dart';
import '../../features/spec/presentation/specs_screen.dart';
import '../../features/story/presentation/story_create_screen.dart';
import '../../features/story/presentation/story_edit_screen.dart';
import '../../features/story/presentation/story_player_screen.dart';
import '../../features/story/presentation/story_screen.dart';
import '../../features/worlds/presentation/world_detail_screen.dart';
import '../../features/worlds/presentation/world_edit_screen.dart';
import '../../features/worlds/presentation/worldbook_edit_screen.dart';
import '../../features/worlds/presentation/worlds_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatListScreen(),
            routes: [
              GoRoute(
                path: ':sessionId',
                builder: (context, state) => ChatScreen(
                  key: ValueKey(state.pathParameters['sessionId']),
                  sessionId: state.pathParameters['sessionId']!,
                ),
              ),
              GoRoute(
                path: 'group/create',
                builder: (context, state) => const GroupCreateScreen(),
              ),
              GoRoute(
                path: 'group/:groupId',
                builder: (context, state) => GroupChatScreen(
                  key: ValueKey(state.pathParameters['groupId']),
                  groupId: state.pathParameters['groupId']!,
                ),
                routes: [
                  GoRoute(
                    path: 'info',
                    builder: (context, state) => GroupInfoScreen(
                      key: ValueKey(state.pathParameters['groupId']),
                      groupId: state.pathParameters['groupId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/story',
            builder: (context, state) => const StoryScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const StoryCreateScreen(),
              ),
              GoRoute(
                path: ':storyId',
                builder: (context, state) => StoryPlayerScreen(
                  key: ValueKey(state.pathParameters['storyId']),
                  storyId: state.pathParameters['storyId']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => StoryEditScreen(
                      key: ValueKey(state.pathParameters['storyId']),
                      storyId: state.pathParameters['storyId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/contacts',
            builder: (context, state) => const ContactsScreen(),
            routes: [
              GoRoute(
                path: 'import',
                builder: (context, state) => const CharacterImportScreen(),
              ),
              GoRoute(
                path: 'create',
                builder: (context, state) => const CharacterEditScreen(),
              ),
              GoRoute(
                path: ':characterId',
                builder: (context, state) => CharacterDetailScreen(
                  key: ValueKey(state.pathParameters['characterId']),
                  characterId: state.pathParameters['characterId']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => CharacterEditScreen(
                      key: ValueKey(state.pathParameters['characterId']),
                      characterId: state.pathParameters['characterId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/worlds',
            builder: (context, state) => const WorldsScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const WorldEditScreen(),
              ),
              GoRoute(
                path: ':worldId',
                builder: (context, state) => WorldDetailScreen(
                  key: ValueKey(state.pathParameters['worldId']),
                  worldId: state.pathParameters['worldId']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => WorldEditScreen(
                      key: ValueKey(state.pathParameters['worldId']),
                      worldId: state.pathParameters['worldId']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'worldbooks/new',
                builder: (context, state) => const WorldbookEditScreen(),
              ),
              GoRoute(
                path: 'worldbooks/:worldbookId/edit',
                builder: (context, state) => WorldbookEditScreen(
                  key: ValueKey(state.pathParameters['worldbookId']),
                  worldbookId: state.pathParameters['worldbookId']!,
                ),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'providers',
                builder: (context, state) => const ProviderSettingsScreen(),
              ),
              GoRoute(
                path: 'presets',
                builder: (context, state) => const PresetSettingsScreen(),
              ),
              GoRoute(
                path: 'assistants',
                builder: (context, state) => const AssistantsScreen(),
              ),
              GoRoute(
                path: 'specs',
                builder: (context, state) => const SpecsScreen(),
                routes: [
                  GoRoute(
                    path: ':key',
                    builder: (context, state) => DocScreen(
                      key: ValueKey(state.pathParameters['key']),
                      docKey: state.pathParameters['key']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: 'manual',
                builder: (context, state) => const DocScreen(docKey: 'manual'),
              ),
            ],
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
  ],
);
