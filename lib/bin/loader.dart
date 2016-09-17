part of coUemoticons;

Future _loadEmojione(Asset json) async {
	await json.load();

	json.get().forEach((String id, Map<String, dynamic> emoticon) {
		if (emoticon['name'].contains('modifier')) {
			return;
		}

		try {
			_emoticons.addAll({id: new Emoticon(
				id: id,
				unicode: emoticon['unicode'],
				name: emoticon['name'],
				shortname: emoticon['shortname'],
				category: emoticon['category'],
				order: int.parse(emoticon['emoji_order']),
				aliases: emoticon['aliases_ascii'],
				keywords: emoticon['keywords']
			)});
		} catch (e) {
			print('coUemoticons: Could not load emoticon $id: $e');
		}
	});
}

Future _loadCou(Asset json) async {
	await json.load();

	json.get()['names'].forEach((String id) {
		try {
			_emoticons.addAll({id: new Emoticon(
				id: id,
				name: id,
				shortname: ':$id:',
				category: 'CoU'
			)});
		} catch (e) {
			print('coUemoticons: Could not load emoticon $id: $e');
		}
	});
}