public interface IContactSelector {
  ContactCountingWrapper[] getContactCountings(Set<Id> contactIDs);
}
