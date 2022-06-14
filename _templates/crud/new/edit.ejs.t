---
to: pages/<%= h.changeCase.lower(h.inflection.pluralize(name)) %>/[id]/edit.vue
---
<%
  Fields = (locals.fields || '').split(',').map(v => v.split(':'));
  FieldNames = Fields.map(v => v[0]);
  PascalName = h.changeCase.pascal(name);
  PluralName = h.inflection.pluralize(name);
  SingularName = h.inflection.singularize(name);
  LowerPluralName = h.changeCase.lower(PluralName);
  LowerSingularName = h.changeCase.lower(SingularName);
  PascalPluralName = h.changeCase.pascal(PluralName);
  PascalSingularName = h.changeCase.pascal(SingularName);
%>
<script setup lang="ts">
import { VBreadcrumbItem } from '@gits-id/breadcrumbs';
import { FormEvent } from '~~/types/form';

const route = useRoute();

const breadcrumbs = ref<VBreadcrumbItem[]>([
  {
    title: '<%= PascalName %> Management',
    to: '/users',
  },
  {
    title: 'Create',
    to: `/<%= LowerPluralName %>/${route.params.id}/edit`,
  },
]);

const { update, find } = use<%= PascalName %>();
const router = useRouter();
const loading = ref(false);

const id = computed(() => String(route.params.id));

const onSubmit = async ({ values }: FormEvent) => {
  const { refresh } = update(id.value, values);

  loading.value = true;
  await refresh();
  loading.value = false;

  router.push('/<%= LowerPluralName %>');
};

const { data: item, pending } = await find(id.value);
</script>

<template>
  <div>
    <PageHeader title="Edit <%= PascalName %>" :breadcrumbs="breadcrumbs" />

    <<%= PascalName %>Form
      @submit="onSubmit"
      :loading="loading || pending"
      :initial-values="item"
    />
  </div>
</template>
