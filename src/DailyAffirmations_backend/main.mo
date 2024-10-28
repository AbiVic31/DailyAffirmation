import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type AffirmationId = Nat;
  
  private type AffirmationStore = {
    id: AffirmationId;
    content: Text;
    category: Text;
    tags: Buffer.Buffer<Text>;
    date: Time.Time;
  };

  public type AffirmationPublic = {
    id: AffirmationId;
    content: Text;
    category: Text;
    tags: [Text];
    date: Time.Time;
  };

  var affirmations = Buffer.Buffer<AffirmationStore>(0);

  public func addAffirmation(content: Text, category: Text, tags: [Text]) : async AffirmationId {
    let affirmationId = affirmations.size();
    let tagsBuffer = Buffer.Buffer<Text>(0);
    for (tag in tags.vals()) {
      tagsBuffer.add(tag);
    };
    
    let newAffirmation: AffirmationStore = {
      id = affirmationId;
      content = content;
      category = category;
      tags = tagsBuffer;
      date = Time.now();
    };
    affirmations.add(newAffirmation);
    affirmationId
  };

  public query func getAffirmation(id: AffirmationId) : async ?AffirmationPublic {
    if (id >= affirmations.size()) {
      return null;
    };
    
    let affirmation = affirmations.get(id);
    ?{
      id = affirmation.id;
      content = affirmation.content;
      category = affirmation.category;
      tags = Buffer.toArray(affirmation.tags);
      date = affirmation.date;
    }
  };

  public query func getAllAffirmations() : async [AffirmationPublic] {
    let results = Buffer.Buffer<AffirmationPublic>(0);
    
    for (affirmation in affirmations.vals()) {
      results.add({
        id = affirmation.id;
        content = affirmation.content;
        category = affirmation.category;
        tags = Buffer.toArray(affirmation.tags);
        date = affirmation.date;
      });
    };
    Buffer.toArray(results)
  };

  public query func getAffirmationsByCategory(category: Text) : async [AffirmationPublic] {
    let filtered = Buffer.Buffer<AffirmationPublic>(0);

    for (affirmation in affirmations.vals()) {
      if (Text.equal(affirmation.category, category)) {
        filtered.add({
          id = affirmation.id;
          content = affirmation.content;
          category = affirmation.category;
          tags = Buffer.toArray(affirmation.tags);
          date = affirmation.date;
        });
      };
    };
    Buffer.toArray(filtered)
  };
};