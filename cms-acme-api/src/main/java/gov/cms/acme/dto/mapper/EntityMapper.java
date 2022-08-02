package gov.cms.acme.dto.mapper;

import java.util.List;

public interface EntityMapper<E, D> {

    public E toEntity(D dto);

    public D toDto(E entity);

    public List<E> toEntity(List<D> dtoList);

    public List <D> toDto(List<E> entityList);

}
