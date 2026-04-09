import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

/// Social tab entry point.
///
/// - If user is logged in (Firebase Auth) => show SocialHomeView.
/// - If not logged in => show Sign in / Sign up screen.
class SocialTabView extends StatelessWidget {
  const SocialTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // If Firebase wasn't initialized (or config is missing), any call to
    // FirebaseAuth.instance will throw: [core/no-app].
    if (Firebase.apps.isEmpty) {
      return const _FirebaseNotConfigured();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If Firebase isn't configured, authStateChanges can throw.
        if (snapshot.hasError) {
          return _FirebaseNotConfigured(error: snapshot.error);
        }

        final user = snapshot.data;
        if (user == null) {
          return const SocialAuthView();
        }
        return SocialHomeView(user: user);
      },
    );
  }
}

class _FirebaseNotConfigured extends StatelessWidget {
  final Object? error;
  const _FirebaseNotConfigured({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Firebase is not configured for this app build.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text('To enable Social tab:'),
            const SizedBox(height: 10),
            const Text(
              '1) Run: flutterfire configure (recommended)\n'
              '2) Or add config files and rebuild.',
            ),
            const SizedBox(height: 10),
            const Text('Android: android/app/google-services.json'),
            const Text('iOS: ios/Runner/GoogleService-Info.plist'),
            const Text(
              'Web: set Firebase options via flutterfire (firebase_options.dart)',
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(
                'Error: $error',
                style: const TextStyle(color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }
}

class SocialAuthView extends StatefulWidget {
  const SocialAuthView({super.key});

  @override
  State<SocialAuthView> createState() => _SocialAuthViewState();
}

class _SocialAuthViewState extends State<SocialAuthView>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebffff),
      appBar: AppBar(
        title: const Text('Social'),
        backgroundColor: const Color(0xffebffff),
        elevation: 0,
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Sign In'),
            Tab(text: 'Sign Up'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [_EmailPasswordSignIn(), _EmailPasswordSignUp()],
      ),
    );
  }
}

class _EmailPasswordSignIn extends StatefulWidget {
  const _EmailPasswordSignIn();

  @override
  State<_EmailPasswordSignIn> createState() => _EmailPasswordSignInState();
}

class _EmailPasswordSignInState extends State<_EmailPasswordSignIn> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? e.code);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pass,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _loading ? null : _signIn,
              child: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tip: If you want phone login too, enable Phone provider in Firebase Auth and add OTP flow.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _EmailPasswordSignUp extends StatefulWidget {
  const _EmailPasswordSignUp();

  @override
  State<_EmailPasswordSignUp> createState() => _EmailPasswordSignUpState();
}

class _EmailPasswordSignUpState extends State<_EmailPasswordSignUp> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_pass.text != _confirm.text) {
      setState(() => _error = 'Password does not match');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? e.code);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pass,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirm,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _loading ? null : _signUp,
              child: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create account'),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialHomeView extends StatelessWidget {
  final User user;
  const SocialHomeView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _SocialFeed(user: user);
  }
}

/// MVP Social Feed (Phase 1)
/// - Create text + optional image post
/// - Feed list with pagination
/// - Like (toggle)
/// - Comments (basic)
class _SocialFeed extends StatefulWidget {
  final User user;
  const _SocialFeed({required this.user});

  @override
  State<_SocialFeed> createState() => _SocialFeedState();
}

class _SocialFeedState extends State<_SocialFeed> {
  static const _pageSize = 10;
  final _scroll = ScrollController();

  final _posts = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
  DocumentSnapshot<Map<String, dynamic>>? _last;
  bool _loading = false;
  bool _hasMore = true;
  String? _error;

  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance.collection('social_posts');

  @override
  void initState() {
    super.initState();
    _loadFirst();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadFirst() async {
    setState(() {
      _loading = true;
      _error = null;
      _posts.clear();
      _last = null;
      _hasMore = true;
    });

    try {
      final q = await _col
          .orderBy('createdAt', descending: true)
          .limit(_pageSize)
          .get();
      setState(() {
        _posts.addAll(q.docs);
        _last = q.docs.isEmpty ? null : q.docs.last;
        _hasMore = q.docs.length == _pageSize;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loading || !_hasMore || _last == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final q = await _col
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_last!)
          .limit(_pageSize)
          .get();
      setState(() {
        _posts.addAll(q.docs);
        _last = q.docs.isEmpty ? _last : q.docs.last;
        _hasMore = q.docs.length == _pageSize;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _openCreatePost() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => _CreatePostView(user: widget.user)),
    );
    if (created == true) {
      await _loadFirst();
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
        actions: [
          IconButton(
            tooltip: 'My profile',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => _ProfileView(user: widget.user),
                ),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreatePost,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _loadFirst,
        child: ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.all(12),
          itemCount: _posts.length + 1,
          itemBuilder: (context, index) {
            if (index == _posts.length) {
              if (_error != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Error: $_error',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }
              if (_loading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!_hasMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('No more posts')),
                );
              }
              return const SizedBox(height: 80);
            }

            final doc = _posts[index];
            return _PostCard(
              doc: doc,
              currentUid: widget.user.uid,
              onOpenComments: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _CommentsView(
                      postId: doc.id,
                      currentUid: widget.user.uid,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final String currentUid;
  final VoidCallback onOpenComments;

  const _PostCard({
    required this.doc,
    required this.currentUid,
    required this.onOpenComments,
  });

  DocumentReference<Map<String, dynamic>> get _ref => doc.reference;

  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final text = (data['text'] as String?)?.trim() ?? '';
    final imageUrl = data['imageUrl'] as String?;
    final authorName = data['authorName'] as String?;
    final likeCount = (data['likeCount'] as int?) ?? 0;
    final commentCount = (data['commentCount'] as int?) ?? 0;

    final reactionsRef = _ref.collection('reactions').doc(currentUid);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authorName ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (text.isNotEmpty) ...[const SizedBox(height: 8), Text(text)],
            if (imageUrl != null && imageUrl.isNotEmpty) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(imageUrl, fit: BoxFit.cover),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: reactionsRef.snapshots(),
                  builder: (context, snap) {
                    final liked = snap.data?.exists == true;
                    return TextButton.icon(
                      onPressed: () async {
                        await _toggleLike(
                          postRef: _ref,
                          reactionRef: reactionsRef,
                          liked: liked,
                        );
                      },
                      icon: Icon(
                        liked ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text('Like ($likeCount)'),
                    );
                  },
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onOpenComments,
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: Text('Comment ($commentCount)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleLike({
    required DocumentReference<Map<String, dynamic>> postRef,
    required DocumentReference<Map<String, dynamic>> reactionRef,
    required bool liked,
  }) async {
    await FirebaseFirestore.instance.runTransaction((tx) async {
      final postSnap = await tx.get(postRef);
      final current = (postSnap.data()?['likeCount'] as int?) ?? 0;

      if (liked) {
        tx.delete(reactionRef);
        tx.update(postRef, {'likeCount': (current - 1).clamp(0, 1 << 31)});
      } else {
        tx.set(reactionRef, {
          'type': 'like',
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.update(postRef, {'likeCount': current + 1});
      }
    });
  }
}

class _CreatePostView extends StatefulWidget {
  final User user;
  const _CreatePostView({required this.user});

  @override
  State<_CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<_CreatePostView> {
  final _text = TextEditingController();
  XFile? _image;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;
      setState(() {
        _image = file;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _submit() async {
    final text = _text.text.trim();
    if (text.isEmpty && _image == null) {
      setState(() => _error = 'Write something or select an image.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });

    final postId = const Uuid().v4();
    String? imageUrl;

    try {
      if (_image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('social_posts')
            .child(widget.user.uid)
            .child('$postId.jpg');

        final bytes = await _image!.readAsBytes();
        await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance
          .collection('social_posts')
          .doc(postId)
          .set({
            'uid': widget.user.uid,
            'authorEmail': widget.user.email,
            'authorName':
                widget.user.displayName ?? (widget.user.email ?? 'User'),
            'text': text,
            'imageUrl': imageUrl,
            'createdAt': FieldValue.serverTimestamp(),
            'likeCount': 0,
            'commentCount': 0,
          });

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _text,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _saving ? null : _pickImage,
                  icon: const Icon(Icons.image_outlined),
                  label: Text(_image == null ? 'Add image' : 'Change image'),
                ),
                const SizedBox(width: 10),
                if (_image != null) const Text('Selected'),
              ],
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Post'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentsView extends StatefulWidget {
  final String postId;
  final String currentUid;
  const _CommentsView({required this.postId, required this.currentUid});

  @override
  State<_CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<_CommentsView> {
  final _text = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  CollectionReference<Map<String, dynamic>> get _comments => FirebaseFirestore
      .instance
      .collection('social_posts')
      .doc(widget.postId)
      .collection('comments');

  Future<void> _send() async {
    final txt = _text.text.trim();
    if (txt.isEmpty) return;
    setState(() => _sending = true);
    try {
      final commentId = const Uuid().v4();
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final postRef = FirebaseFirestore.instance
            .collection('social_posts')
            .doc(widget.postId);
        final postSnap = await tx.get(postRef);
        final current = (postSnap.data()?['commentCount'] as int?) ?? 0;

        tx.set(_comments.doc(commentId), {
          'uid': widget.currentUid,
          'text': txt,
          'createdAt': FieldValue.serverTimestamp(),
        });
        tx.update(postRef, {'commentCount': current + 1});
      });

      _text.clear();
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _comments
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snap.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('No comments yet'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final d = docs[i].data();
                    return ListTile(
                      title: Text(d['text'] ?? ''),
                      subtitle: Text(d['uid'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _text,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final User user;
  const _ProfileView({required this.user});

  @override
  Widget build(BuildContext context) {
    final uid = user.uid;
    final col = FirebaseFirestore.instance.collection('social_posts');

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.displayName ?? (user.email ?? 'User'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(uid, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            const Text(
              'My Posts',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: col
                    .where('uid', isEqualTo: uid)
                    .orderBy('createdAt', descending: true)
                    .limit(50)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snap.error}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snap.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text('No posts yet'));
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      final d = docs[i].data();
                      return ListTile(
                        title: Text((d['text'] ?? '').toString()),
                        subtitle: Text(
                          'Likes: ${d['likeCount'] ?? 0}  |  Comments: ${d['commentCount'] ?? 0}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
