package it.bookBorrow.dataBase.query;

/**
 *
 * @author alessandro
 */
public interface ParamQueryExec extends QueryExec{
    public void setParameters(Object ... obj);
}
