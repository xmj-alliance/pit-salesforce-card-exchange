public interface IAccountSelector {
  Account[] selectByID(Set<Id> ids);
}
