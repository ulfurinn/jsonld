defmodule UlfNet.JSONLDTest do
  use ExUnit.Case

  @document """
  {
    "@context": [
      "https://www.w3.org/ns/activitystreams",
      "https://w3id.org/security/v1",
      {
        "manuallyApprovesFollowers": "as:manuallyApprovesFollowers",
        "toot": "http://joinmastodon.org/ns#",
        "featured": {
          "@id": "toot:featured",
          "@type": "@id"
        },
        "featuredTags": {
          "@id": "toot:featuredTags",
          "@type": "@id"
        },
        "alsoKnownAs": {
          "@id": "as:alsoKnownAs",
          "@type": "@id"
        },
        "movedTo": {
          "@id": "as:movedTo",
          "@type": "@id"
        },
        "schema": "http://schema.org#",
        "PropertyValue": "schema:PropertyValue",
        "value": "schema:value",
        "discoverable": "toot:discoverable",
        "suspended": "toot:suspended",
        "memorial": "toot:memorial",
        "indexable": "toot:indexable",
        "attributionDomains": {
          "@id": "toot:attributionDomains",
          "@type": "@id"
        },
        "focalPoint": {
          "@container": "@list",
          "@id": "toot:focalPoint"
        }
      }
    ],
    "id": "https://mastodon.example.com/users/alice",
    "type": "Person",
    "following": "https://mastodon.example.com/users/alice/following",
    "followers": "https://mastodon.example.com/users/alice/followers",
    "inbox": "https://mastodon.example.com/users/alice/inbox",
    "outbox": "https://mastodon.example.com/users/alice/outbox",
    "featured": "https://mastodon.example.com/users/alice/collections/featured",
    "featuredTags": "https://mastodon.example.com/users/alice/collections/tags",
    "preferredUsername": "alice",
    "name": "Alice",
    "summary": "Definitely a real person.",
    "url": "https://mastodon.example.com/@alice",
    "manuallyApprovesFollowers": false,
    "discoverable": true,
    "indexable": true,
    "published": "2020-01-01T00:00:00Z",
    "memorial": false,
    "attributionDomains": [
      "alice.xyz"
    ],
    "publicKey": {
      "id": "https://mastodon.example.com/users/alice#main-key",
      "owner": "https://mastodon.example.com/users/alice",
      "publicKeyPem": "-----BEGIN PUBLIC KEY-----"
    },
    "tag": [],
    "attachment": [
      {
        "type": "PropertyValue",
        "name": "home",
        "value": "alice.xyz"
      },
      {
        "type": "PropertyValue",
        "name": "github",
        "value": "https://github.com/alice"
      }
    ],
    "endpoints": {
      "sharedInbox": "https://mastodon.example.com/inbox"
    },
    "icon": {
      "type": "Image",
      "mediaType": "image/jpeg",
      "url": "http://example.com/icon.jpg"
    },
    "image": {
      "type": "Image",
      "mediaType": "image/jpeg",
      "url": "http://example.com/image.jpg"
    }
  }
  """

  defmodule Person do
    use UlfNet.JSONLD

    vocab as: "https://www.w3.org/ns/activitystreams#", toot: "http://joinmastodon.org/ns#" do
      field(:image, "as:image")
      field(:discoverable, "toot:discoverable")
    end
  end

  defmodule Image do
    use UlfNet.JSONLD

    vocab as: "https://www.w3.org/ns/activitystreams#" do
      field(:media_type, "as:mediaType")
      field(:url, "as:url")
    end
  end

  setup _ do
    %{document: JSON.LD.expand(JSON.decode!(@document))}
  end

  test "fetches properties", %{document: [document]} do
    assert [image] = Person.image(document)
    assert [%{"@value" => "image/jpeg"}] = Image.media_type(image)
    assert [%{"@id" => "http://example.com/image.jpg"}] = Image.url(image)
  end
end
