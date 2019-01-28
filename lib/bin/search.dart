part of coUemoticons;

class _SortingEmoticon extends Emoticon implements Comparable {
	/// Emoticon we're sorting
	Emoticon emoticon;

	/// Lower number means more relevant
	int relevance;

	_SortingEmoticon(this.emoticon, this.relevance);

	@override
	String toString() => '[$relevance] $emoticon';

	@override
	int compareTo(dynamic other) {
		assert(other is _SortingEmoticon);
		return this.relevance.compareTo(other.relevance);
	}
}

Map<String, List<Emoticon>> _searchCache = {};

int levenshteinDistance(String string1, String string2) {
	// best case: empty strings;
	if (string1.length == 0) {
		return string2.length;
	} else if (string2.length == 0) {
		return string1.length;
	}

	// test if last characters of the strings match
	int cost;
	if (string1.substring(-1) == string2.substring(-1)) {
		cost = 0;
	} else {
		cost = 1;
	}

	// return minimum of delete char from s, delete char from t, and delete char from both
	String string1MinusLast = string1.substring(0, string1.length - 1);
	String string2MinusLast = string2.substring(0, string2.length - 1);
	return min(
		min(
			levenshteinDistance(string1MinusLast, string2) + 1,
			levenshteinDistance(string1, string2MinusLast) + 1
		),
		levenshteinDistance(string1MinusLast, string2MinusLast) + cost
	);
}

List<Emoticon> search(String needle) {
	// Clean up input
	needle = needle.trim().toLowerCase();

	// Check cache
	if (_searchCache[needle] != null) {
		return _searchCache[needle];
	}

	// Find how closely each emoticon matches
	List<_SortingEmoticon> pile = [];
	emoticons.forEach((Emoticon emoticon) {
		int relevance = min(levenshteinDistance(emoticon.name, needle),
			levenshteinDistance(emoticon.shortname, needle)) * 2;

		if (emoticon.keywords.join(',').contains(needle)) {
			relevance ~/= 2;
		}

		pile.add(new _SortingEmoticon(emoticon, relevance));
	});

	// Limit the number returned
	pile = pile.where((_SortingEmoticon emoticon) {
		return emoticon.relevance <= needle.length;
	}).toList();

	// Sort by relevance
	pile.sort();

	// Convert _SortingEmoticons back into emoticons
	List<Emoticon> pileEmoticons = [];
	pile.forEach((_SortingEmoticon emoticon) {
		pileEmoticons.add(emoticon.emoticon);
	});

	// Save to cache for later
	_searchCache[needle] = pileEmoticons;

	return pileEmoticons;
}
